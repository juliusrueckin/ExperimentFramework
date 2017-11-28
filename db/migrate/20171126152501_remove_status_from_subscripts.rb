class RemoveStatusFromSubscripts < ActiveRecord::Migration[5.1]
  def change
    remove_column :subscripts, :status, :integer
  end
end
