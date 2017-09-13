class CreateSubscriptDependencies < ActiveRecord::Migration[5.1]
  def change
    create_table :subscript_dependencies do |t|
      t.integer :parent_script_id
      t.integer :child_script_id
      t.integer :algorithM_id

      t.timestamps
    end
  end
end
