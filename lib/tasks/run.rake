# coding: utf-8

namespace :redmine do
  namespace :plugin do
    namespace :closers do
      desc 'Close issues by rule'
      task :run => :environment do

        puts "***"
        puts "Start at #{Time.now}"

        settings = Setting.find_by_name('plugin_closers').value if Setting.find_by_name('plugin_closers')
        user = User.find_by_id settings[:user_id]

        if settings && user
            if !ClosureRule.all.empty?
                ClosureRule.all.each do |rule|
                    puts "Rule ##{rule.id}"
                    puts "----------------"

                    date = rule.after_on ? Time.zone.local(rule.after_on.year.to_i, rule.after_on.month.to_i, rule.after_on.day.to_i) : Time.zone.now
                    date = date - (idle_time * 3600) if idle_time
                    
                    Issue.where(project_id: rule.projects, tracker_id: rule.trackers, status_id: rule.statuses, active: true).where("updated_on < '#{date}'").each do |issue|
                        old_status_id = issue.status_id

                        if issue.update_attribute :status_id, rule.close_status_id
                            journal = issue.init_journal user
                            if journal.save!
                                journal.details.create! property: "attr", prop_key: "status_id", old_value: old_status_id, value: issue.status_id
                                puts "Issue ##{issue.id} was closed"
                            end
                        end
                    end
                end
            else
                puts "You have no closure rules for issues"
            end
        else
            puts "Not found settings for plugin"
        end

        puts "End at #{Time.now}"
        puts "***"

      end
    end
  end
end