class AddStatusToSubscript < ActiveRecord::Migration[5.1]
  def change
    add_column :subscripts, :status, :integer
  end
end
