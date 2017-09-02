class RenameConfigurationIdToSettingIdInExperiments < ActiveRecord::Migration[5.1]
  def change
  	rename_column :experiments, :configuration_id, :setting_id
  end
end
