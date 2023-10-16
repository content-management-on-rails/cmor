class CreateCmorCoreSettingsValues < ActiveRecord::Migration[6.1]
  def change
    create_table :cmor_core_settings_values do |t|
      t.string :namespace
      t.string :key
      t.string :content

      t.timestamps
    end
  end
end
