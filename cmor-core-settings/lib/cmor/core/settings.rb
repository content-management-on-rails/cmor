require "cmor/core/settings/engine"
require "cmor/core/settings/setting"
require "cmor/core/settings/configuration"
require "cmor/core/settings/version"

module Cmor
  module Core
    module Settings
      def self.configure
        yield Configuration
      end

      def self.get(namespace, key)
        settable = Cmor::Core::Settings::Setting.where(namespace: namespace, key: key).first!
        settable.value
      end

      def self.set(namespace, key, value)
        settable = Cmor::Core::Settings::Setting.where(namespace: namespace, key: key).first!
        settable.update!(content: value)
      end
    end
  end
end
