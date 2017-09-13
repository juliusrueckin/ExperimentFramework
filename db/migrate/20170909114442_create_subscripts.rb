class CreateSubscripts < ActiveRecord::Migration[5.1]
  def change
    create_table :subscripts do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :file_path
      t.string :filename
      t.integer :algorithm_id

      t.timestamps
    end
  end
end
