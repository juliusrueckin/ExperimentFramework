class DeleteFilePathFromAlgorithm < ActiveRecord::Migration[5.1]
  def change
  	remove_column :algorithms, :file_path
  end
end
