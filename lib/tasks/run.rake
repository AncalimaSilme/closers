# coding: utf-8

namespace :redmine do
  namespace :plugin do
    namespace :closers do
      desc 'Close issues by rule'
      task :run => :environment do

        puts "***"
        puts "Start at #{Time.now}"

        settings = Setting.find_by_name('plugin_closers').value if Setting.find_by_name('plugin_closers')

        if settings && settings[:user_id]
            ClosureRule.all.each do |rule|
                puts "Rule ##{rule.id}"
                puts "----------------"

                Issue.where(project_id: rule.projects, tracker_id: rule.trackers, status_id: rule.statuses).each do |issue|
                    if issue.updated_on < (Time.zone.now - (rule.idle_time * 3600))
                        puts "Issue ##{issue.id} corresponds to the rule ##{rule.id}"
                        
                        if User.find_by_id settings[:user_id]
                            old_status_id = issue.status_id

                            if issue.update_attribute :status_id, rule.close_status_id
                                journal = issue.init_journal User.find_by_id settings[:user_id]
                                if journal.save!
                                    journal.details.create! property: "attr", prop_key: "status_id", old_value: old_status_id, value: issue.status_id
                                    puts "Issue ##{issue.id} was closed"
                                end
                            end
                        else
                            puts "Not found user by user_id: #{settings[:user_id]}"
                        end
                    end
                end
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