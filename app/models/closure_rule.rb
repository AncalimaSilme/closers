class ClosureRule < ActiveRecord::Base
    serialize :projects, Array
    serialize :trackers, Array
    serialize :statuses, Array
    
    validates_presence_of :projects, :trackers, :statuses, :idle_time, :close_status_id

    before_save :delete_empty_items

    private

        def delete_empty_items
            [:projects, :trackers, :statuses].each do |field|
                self.send(field).delete_if { |item| item.blank? }
            end
        end
end