# coding: utf-8

namespace :redmine do
  namespace :plugin do
    namespace :closers do
      desc 'Close issues by rule'
      task :run, [:rule_id] => :environment do |task, args|
        puts "***"
        puts "Start at #{Time.now}"

        settings = Setting.find_by_name('plugin_closers').value if Setting.find_by_name('plugin_closers')
        user = User.find_by_id settings[:user_id]

        if settings && user
            rules = []

            if args[:rule_id]
                if ClosureRule.find_by_id(args[:rule_id])
                    rules = [ ClosureRule.find_by_id(args[:rule_id]) ]
                else
                    puts "Not found closure rule with id: #{args[:rule_id]}" 
                end
            else
                rules = ClosureRule.where(active: true)
                puts "You have no closure rules for issues" if rules.blank?
            end

            rules.each do |rule|
                puts "Rule ##{rule.id}"
                puts "----------------"

                date = rule.after_on ? Time.new(rule.after_on.year.to_i, rule.after_on.month.to_i, rule.after_on.day.to_i) : Time.now
                date = date - (rule.idle_time * 3600) if rule.idle_time

                Issue.where(project_id: rule.projects, tracker_id: rule.trackers, status_id: rule.statuses).where("updated_on < '#{date}'").each do |issue|
                    old_status_id = issue.status_id

                    if issue.update_attribute :status_id, rule.close_status_id
                        journal = issue.init_journal user
                        if journal.save!
                            journal.details.create! property: "attr", prop_key: "status_id", old_value: old_status_id, value: issue.status_id
                            puts "Issue ##{issue.id} was closed"
                        end
                    end
                end
            end unless rules.blank?
        else
            puts "Not found settings for plugin"
        end

        puts "End at #{Time.now}"
        puts "***"
      end
    end
  end
end