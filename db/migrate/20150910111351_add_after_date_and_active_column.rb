class AddAfterDateAndActiveColumn < ActiveRecord::Migration
  def up
    add_column :closure_rules, :after_on, :datetime
    add_column :closure_rules, :active, :boolean
  end

  def down
    remove_column :closure_rules, :after_on, :datetime
    remove_column :closure_rules, :active, :boolean
  end
end
