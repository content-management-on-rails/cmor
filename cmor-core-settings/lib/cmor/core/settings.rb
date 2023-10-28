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

      # Usage:
      #
      #   self.get("foo", "bar.baz") # => :qux
      #   self.get("foo/bar.baz")    # => :qux
      #
      def self.get(namespace_or_path, key = nil)
        if namespace_or_path.to_s.include?("/") && key.nil?
          namespace, key = namespace_or_path.to_s.split("/")
        else
          namespace = namespace_or_path
        end

        settable = Cmor::Core::Settings::Setting.where(namespace: namespace.to_sym, key: key.to_sym).first!
        settable.value
      end

      def self.paths
        Cmor::Core::Settings::Setting.all.map { |s| [s.namespace, s.key].join("/") }
      end

      # Usage:
      #
      #   self.set("foo", "bar.baz", :qux)
      #   self.set("foo/bar.baz", :qux)
      #
      def self.set(*args)
        if args.size == 2
          namespace_or_path, value = args
          namespace, key = namespace_or_path.to_s.split("/")
        else
          namespace_or_path, key, value = args
          namespace = namespace_or_path
        end

        settable = Cmor::Core::Settings::Setting.where(namespace: namespace.to_sym, key: key.to_sym).first!
        settable.update!(content: value)
      end
    end
  end
end
