class RenameAlgorithMIdInSubscriptDependencies < ActiveRecord::Migration[5.1]
  def change
  	rename_column :subscript_dependencies, :algorithM_id, :algorithm_id
  end
end
