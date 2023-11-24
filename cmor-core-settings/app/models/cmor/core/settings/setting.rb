module Cmor::Core::Settings
  class Setting < ApplicationRecord
    self.inheritance_column = nil
    
    has_many :values, inverse_of: :setting, dependent: :destroy, autosave: true
    has_one :value, -> { order(created_at: :desc) }, inverse_of: :setting, dependent: :destroy, autosave: true

    accepts_nested_attributes_for :value, allow_destroy: true
    accepts_nested_attributes_for :values, reject_if: :all_blank, allow_destroy: true

    validates :namespace, presence: true
    validates :key, presence: true, uniqueness: { scope: :namespace }
    validates :type, presence: true, inclusion: { in: %w(array boolean hash integer password string) }

    serialize :default, coder: JSON

    def human
      path
    end

    def path
      "#{namespace}/#{key}"
    end

    def value_content=(value)
      if self.type == "array"
        self.values = typecast_value(value).collect do |v|
          self.values.build(content: v)
        end
        # self.values.first_or_initialize.content = value
      else
        (self.value ||= build_value).content = value
      end
    end

    def value_content
      if self.type == "array"
        if self.values.any?
          self.values.collect(&:content)
        else
          typecast_value(default)
        end
      else
        if self.value.present?
          typecast_value(self.value.content)
        else
          typecast_value(default)
        end
      end
    end

    def current_value
      value_content
    end

    def typecast_value(value)
      return nil if value.nil?
      case type.to_sym
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
      when :string, :password
        value.to_s
      else
        raise "Unknown type: #{type.inspect}"
      end
    end
  end
end
