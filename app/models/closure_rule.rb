class ClosureRule < ActiveRecord::Base
    serialize :projects, Array
    serialize :trackers, Array
    serialize :statuses, Array
    
    validates_presence_of :projects, :trackers, :statuses, :close_status_id
    validates_with AnyFieldValidator, fields: [:after_on, :idle_time]
    validates :idle_time, :numericality => { :greater_than_or_equal_to => 0, :allow_nil => true, :message => :invalid }
    validates :after_on, :date => true

    before_save :delete_empty_items

    private

        def delete_empty_items
            [:projects, :trackers, :statuses].each do |field|
                self.send(field).delete_if { |item| item.blank? }
            end
        end
end