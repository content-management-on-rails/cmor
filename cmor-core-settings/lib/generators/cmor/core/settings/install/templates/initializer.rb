Cmor::Core::Settings.configure do |config|
  # Register self to be shown in the backend.
  #
  # Default: config.register_engine("Cmor::Core::Settings::Engine", {})
  #
  config.cmor.administrador.register_engine("Cmor::Core::Settings::Engine", {})

  # Set the resources, that will be shown in the backend menu.
  #
  # Default: config.resources_controllers = -> {[
  #            Cmor::Core::Settings::SettingsController
  #          ]}
  #
  config.resources_controllers = -> {[
    Cmor::Core::Settings::SettingsController
  ]}

  # Set the way to register settings.
  #
  # Default:
  #
  #  config.register_method = ->(namespace:, key:, type:, default:, validations: {}) {
  #    Cmor::Core::Settings::Setting.where(namespace: namespace, key: key).first_or_create!(namespace: namespace, key: key, type: type, default: default, validations: validations)
  #  }
  #
  # Example using multi tenancy:
  #
  # config.register_method = ->(namespace:, key:, type:, default:, validations: {}) {
  #   Cmor::MultiTenancy::Client.all.each do |client|
  #     Cmor::Core::Settings::Setting.where(namespace: namespace, key: key, client: client).first_or_create!(namespace: namespace, key: key, type: type, default: default, validations: validations)
  #   end
  # }
  #
  config.register_method = ->(namespace:, key:, type:, default:, validations: {}) {
    Cmor::Core::Settings::Setting.where(namespace: namespace, key: key).first_or_create!(namespace: namespace, key: key, type: type, default: default, validations: validations)
  }
end
