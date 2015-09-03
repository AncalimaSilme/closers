class ClosureRule < ActiveRecord::Base
    serialize :projects, Array
    serialize :trackers, Array
    serialize :statuses, Array
    
    validates_presence_of :projects, :trackers, :statuses, :idle_time, :close_status_id
end