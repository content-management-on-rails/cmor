class AddSettingIdToCmorCoreSettingsValues < ActiveRecord::Migration[7.0]
  def change
    add_reference :cmor_core_settings_values, :setting, null: false, foreign_key: { to_table: :cmor_core_settings_settings }
  end
end
