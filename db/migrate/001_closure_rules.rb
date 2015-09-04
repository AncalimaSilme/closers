class ClosureRules < ActiveRecord::Migration
  def change
    create_table :closure_rules do |t|
      t.text    :projects,          null: false
      t.text    :trackers,          null: false
      t.text    :statuses,          null: false

      t.integer :idle_time,         null: false
      t.integer :close_status_id,   null: false
      
      t.timestamps
    end
  end
end