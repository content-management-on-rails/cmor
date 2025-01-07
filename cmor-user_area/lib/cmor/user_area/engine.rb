module Cmor::UserArea
  class Engine < ::Rails::Engine
    isolate_namespace Cmor::UserArea

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.to_prepare do
      ActiveSupport.on_load(:active_record) do
        Cmor::Core::Settings.configure do |config|
          config.register(namespace: :cmor_user_area, type: :boolean, key: "user.enable_registrations", default: false, validations: {inclusion: {in: [true, false]}})
          config.register(namespace: :cmor_user_area, type: :boolean, key: "user.allow_users_to_destroy_self", default: false, validations: {inclusion: {in: [true, false]}})
          config.register(namespace: :cmor_user_area, type: :string, key: "user_mailer.application_name", default: Rails.application.class.name.demodulize.humanize, validations: {presence: true})
          config.register(namespace: :cmor_user_area, type: :string, key: "user_mailer.sender", default: nil, validations: {presence: true, format: {with: /.*@.*/}})
          config.register(namespace: :cmor_user_area, type: :boolean, key: "tfa.enable", default: false, validations: {inclusion: {in: [true, false]}})
        end
      end
    end
  end
end
