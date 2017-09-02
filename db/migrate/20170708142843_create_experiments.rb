class CreateExperiments < ActiveRecord::Migration[5.1]
  def change
    create_table :experiments do |t|
      t.string :title
      t.text :description
      t.references :project, foreign_key: true
      t.references :algorithm, foreign_key: true
      t.references :configuration, foreign_key: true
      t.references :dataset, foreign_key: true

      t.timestamps
    end
  end
end
