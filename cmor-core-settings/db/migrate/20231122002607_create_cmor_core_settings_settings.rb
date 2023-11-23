class CreateCmorCoreSettingsSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :cmor_core_settings_settings do |t|
      t.string :key
      t.string :namespace
      t.string :type
      t.string :default
      t.text :validations

      t.timestamps
    end
  end
end
