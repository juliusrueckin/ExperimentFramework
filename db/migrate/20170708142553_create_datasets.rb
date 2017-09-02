class CreateDatasets < ActiveRecord::Migration[5.1]
  def change
    create_table :datasets do |t|
      t.string :title
      t.text :description
      t.string :file_path
      t.string :file_size
      t.integer :dimensions
      t.integer :size

      t.timestamps
    end
  end
end
