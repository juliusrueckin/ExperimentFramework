class CreateSubscriptInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :subscript_instances do |t|
      t.integer :subscript_id
      t.integer :status
      t.integer :progress

      t.timestamps
    end
  end
end
