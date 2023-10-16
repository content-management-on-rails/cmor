module Cmor
  module Core
    module Settings
      class Settable < Rao::ActiveCollection::Base
        attr_accessor :id, :key, :namespace, :default, :validations

        add_attribute_names :value

        validates :namespace, presence: true
        validates :key, presence: true, exclusion: { in: ->(record) { self.all.map(&:id) } }

        def self.generate_primary_key(record)
          Digest::SHA1.hexdigest("#{normalize_namespace(record.namespace)}.#{normalize_key(record.key)}")
        end

        def errors
          if setting&.errors&.any?
            super.dup.tap do |errors|
              setting.errors.select { |e| e.attribute == :value }.each do |error|
                errors.import(error)
              end
              errors
            end
          else
            super
          end
        end

        def setting
          begin
            return nil unless Cmor::Core::Settings::Setting.table_exists?
            @setting ||= Cmor::Core::Settings::Setting.find_or_initialize_by(namespace: namespace, key: key).tap do |setting|
              setting.validations = validations
              setting
            end
          rescue  => e
            if e.class.name == "PG::UndefinedTable"
              puts "[Cmor::Core::Settings::Settable] Table 'cmor_core_settings_settings' does not exist. Please run 'rails cmor_core_settings:install:migrations && rails db:migrate'"
              nil
            else
              raise e
            end
          end
        end

        def update(attributes)
          setting.update(attributes)
        end

        def update!(attributes)
          setting.update!(attributes)
        end

        def value=(value)
          setting.value = value
        end

        def value
          setting.persisted? ? setting.value : default
        end

        def human
          "#{namespace}.#{key}"
        end

        def self.normalize_key(key)
          key.to_s.underscore
        end

        def self.normalize_namespace(namespace)
          namespace.to_s.underscore
        end

        def normalize_key(key)
          self.class.normalize_key(key)
        end

        def normalize_namespace(namespace)
          self.class.normalize_namespace(namespace)
        end
      end
    end
  end
end
