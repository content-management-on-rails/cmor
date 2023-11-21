module Cmor
  module Core
    module Settings
      class Setting < Rao::ActiveCollection::Base
        attr_accessor :id, :key, :namespace, :default, :type, :validations

        add_attribute_names :value

        validates :namespace, presence: true
        validates :key, presence: true, exclusion: { in: ->(record) { self.all.map(&:id) } }
        validates :type, presence: true, inclusion: { in: [:array, :boolean, :hash, :integer, :string] }

        def self.generate_primary_key(record)
          raise "Namespace and key must be present" unless record.namespace.present? && record.key.present?
          Digest::SHA1.hexdigest("#{normalize_namespace(record.namespace)}.#{normalize_key(record.key)}")
        end

        def errors
          if cmor_core_settings_value&.errors&.any?
            super.dup.tap do |errors|
              cmor_core_settings_value.errors.select { |e| e.attribute == :content }.each do |error|
                errors.import(error)
              end
              errors
            end
          else
            super
          end
        end

        def cmor_core_settings_value
          begin
            unless Cmor::Core::Settings::Value.table_exists?
              puts "[Cmor::Core::Settings::Settable] Table 'cmor_core_settings_values' does not exist. Please run 'rails cmor_core_settings:install:migrations && rails db:migrate'"
              return nil
            end
            @cmor_core_settings_value ||= Cmor::Core::Settings::Value.find_or_initialize_by(namespace: namespace, key: key).tap do |record|
              record.validations = validations
            end
          rescue => e
            if e.class.name == "PG::UndefinedTable"
              puts "[Cmor::Core::Settings::Settable] Table 'cmor_core_settings_values' does not exist. Please run 'rails cmor_core_settings:install:migrations && rails db:migrate'"
              nil
            elsif e.class.name == "PG::ConnectionBad"
              puts "[Cmor::Core::Settings::Settable] Could not connect to database."
              nil
            elsif e.class.name == "ActiveRecord::NoDatabaseError"
              puts "[Cmor::Core::Settings::Settable] Could not connect to database. Please run 'rails db:create'"
              nil
            elsif e.class.name == "ActiveRecord::ConnectionNotEstablished"
              puts "[Cmor::Core::Settings::Settable] The database connection is not yet established."
              nil
            else
              raise e
            end
          end
        end

        def namespace=(value)
          @namespace = normalize_namespace(value)
        end

        def key=(value)
          @key = normalize_key(value)
        end

        def type=(value)
          @type = value.to_s.underscore.to_sym
        end

        def update(attributes)
          cmor_core_settings_value&.update(content: attributes[:value])
        end

        def update!(attributes)
          cmor_core_settings_value&.update!(attributes)
        end

        def value=(value)
          cmor_core_settings_value&.content = typecast_value(value)
        end

        def typecast_value(value)
          return nil if value.nil?
          case type
          when :array
            if value.is_a?(Array)
              value
            else
              value.to_s.split(",").map(&:strip)
            end
          when :boolean
            if value.is_a?(TrueClass) || value.is_a?(FalseClass)
              value
            else
              ActiveRecord::Type::Boolean.new.cast(value)
            end
          when :hash
            if value.is_a?(Hash)
              value.with_indifferent_access.deep_symbolize_keys
            else
              JSON.parse(value).with_indifferent_access.deep_symbolize_keys
            end
          when :integer
            value.to_i
          when :string
            value.to_s
          else
            raise "Unknown type: #{type.inspect}"
          end
        end

        def value
          typecast_value(cmor_core_settings_value&.persisted? ? cmor_core_settings_value&.content : default)
        end

        def human
          path
        end

        def path
          "#{namespace}/#{key}"
        end

        def self.normalize_key(key)
          key.to_s.underscore.to_sym
        end

        def self.normalize_namespace(namespace)
          namespace.to_s.underscore.to_sym
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
