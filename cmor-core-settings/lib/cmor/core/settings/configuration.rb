module Cmor
  module Core
    module Settings
      class Configuration
        class << self
          extend Forwardable

          attr_accessor :values

          def define_option(key, default: nil)
            @values[key] = default
            define_singleton_method(key) do
              @values[key]
            end

            define_singleton_method("#{key}=") do |value|
              @values[key] = value
            end
          end

          def cmor
            Cmor
          end
        end

        @values = {}

        define_option :resources_controllers, default: -> { [] }
        define_option :resource_controllers, default: -> { [] }
        define_option :service_controllers, default: -> { [] }
        define_option :sidebar_controllers, default: -> { [] }
        define_option :register_method, default: ->(namespace:, key:, type:, default:, validations: {}) {
          begin
            ActiveSupport.on_load(:active_record) do
              Cmor::Core::Settings::Setting.where(namespace: namespace, key: key).first_or_create!(namespace: namespace, key: key, type: type, default: default, validations: validations)
            end
          rescue => e
            puts "[Cmor::Core::Settings] Error while registering setting #{namespace}/#{key}: #{e.message}"
          end
        }

        def self.register(namespace:, key:, type:, default:, validations: {})
          register_method.call(namespace: namespace, key: key, type: type, default: default, validations: validations)
        rescue StandardError => e
          puts "[Cmor::Core::Settings] Error while registering setting #{namespace}/#{key}: #{e.message}"
        end
      end
    end
  end
end
