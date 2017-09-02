class CreateAlgorithms < ActiveRecord::Migration[5.1]
  def change
    create_table :algorithms do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :file_path
      t.string :time_complexity
      t.string :space_complexity

      t.timestamps
    end
  end
end
