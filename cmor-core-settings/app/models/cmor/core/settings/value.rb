module Cmor::Core::Settings
  class Value < ApplicationRecord
    attr_accessor :default, :validations

    belongs_to :setting, inverse_of: :values

    serialize :content, coder: JSON
    encrypts :content

    after_initialize :set_defaults
    after_initialize :update_validations

    def validations=(value)
      @validations = value
      update_validations
    end

    def run_singleton_class_validations
      self.singleton_class.validators.each do |validator|
        validator.validate(self)
      end
    end

    private

    def set_defaults
      @validations ||= {}
    end

    def update_validations
      return unless validations.is_a?(Hash)
      remove_validations_on_content
      # add validations to the eigenclass
      validations.each do |validation, options|
        if options.is_a?(Hash)
          self.singleton_class.send("validates_#{validation}_of", :content, options)
        else
          self.singleton_class.send("validates_#{validation}_of", :content)
        end
      end
    end

    def remove_validations_on_content
      self.singleton_class.validators.each do |validator|
        self.singleton_class.validators.delete(validator) if validator.attributes.include?(:content)
      end
    end

    def validation_exists?(validation, options)
      validation_for_comparison = "ActiveRecord::Validations::#{validation.to_s.camelize}Validator"
      self.singleton_class.validators.map { |v| [v.class.name, v.attributes] }.include?([validation_for_comparison, [:content]])
    end
  end
end
