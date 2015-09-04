# coding: utf-8

namespace :redmine do
  namespace :plugin do
    namespace :closers do
      desc 'Close issues by rule'
      task :run => :environment do

        settings = Setting.find_by_name('plugin_closers').value if Setting.find_by_name('plugin_closers')

        ClosureRule.all.each do |rule|
            Issue.where("project_id IS " + rule.projects.join(" OR ") + 
                        " AND tracker_id IS " + rule.trackers.join(" OR ") + 
                        " AND status_id IS " + rule.statuses.join(" OR ")).each do |issue|

                # TODO:
                # - подумать над менее быстрой реализацией поиска задач по времен
                
                if issue.updated_on < (Time.now - (rule.idle_time * 60 *60))
                   puts "issue ##{issue.id}"

                    if User.find_by_id settings[:user_id]
                        old_status_id = issue.status_id

                        if issue.update_attribute :status_id, rule.close_status_id
                            journal = issue.init_journal User.find_by_id settings[:user_id]
                            if journal.save!
                                journal.details.create! property: "attr", prop_key: "status_id", old_value: old_status_id, value: issue.status_id
                            end
                        end
                    end
                end
            end
        end

      end
    end
  end
end