class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :title
      t.text :description
      t.string :file_path

      t.timestamps
    end
  end
end
