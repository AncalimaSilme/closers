class ClosureRules < ActiveRecord::Migration
  def change
    create_table :closure_rules do |t|
      t.text    :projects,          null: false
      t.text    :trackers,          null: false
      t.text    :statuses,          null: false

      t.date    :after_on
      t.integer :idle_time
      t.integer :close_status_id,   null: false
      t.boolean :active

      t.timestamps
    end
  end
end