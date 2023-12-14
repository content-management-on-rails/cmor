require "cmor/core/settings/engine"
require "cmor/core/settings/configuration"
require "cmor/core/settings/version"

module Cmor
  module Core
    module Settings
      class AfterInitialize
        def self.set(*args)
          puts "[Cmor::Core::Settings] Caching setting #{args}"
          (@cache ||= []) << args
        end

        def self.run!
          puts "[Cmor::Core::Settings] Setting after_initialize settings:"
          return unless @cache.respond_to?(:each)
          @cache.each do |args|
            puts "[Cmor::Core::Settings] Setting #{args}."
            Cmor::Core::Settings.set(*args)
          end
        end
      end

      class Delayed
        def self.set(*args)
          puts "[Cmor::Core::Settings] Caching setting #{args}."
          (@cache ||= []) << args
        end

        def self.run_later!
          Cmor::Core::Settings::SetCachedJob.perform_later
        end

        def self.run!
          puts "[Cmor::Core::Settings] Setting delayed settings:"
          return unless @cache.respond_to?(:each)
          @cache.each do |args|
            puts "[Cmor::Core::Settings] Setting #{args}"
            Cmor::Core::Settings.set(*args)
          end
        end
      end

      def self.configure
        yield Configuration
      end

      def self.after_initialize
        AfterInitialize
      end

      def self.delayed
        Delayed
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
        settable.current_value
      rescue StandardError => e
        puts "[Cmor::Core::Settings] Error while getting setting #{namespace}/#{key}: #{e.message}"
        nil
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

        setting = Cmor::Core::Settings::Setting.where(namespace: namespace.to_sym, key: key.to_sym).first!
        (setting.value || setting.build_value).update!(content: value)
      rescue StandardError => e
        puts "[Cmor::Core::Settings] Error while setting value for #{namespace}/#{key}: #{e.message}"
      end
    end
  end
end
