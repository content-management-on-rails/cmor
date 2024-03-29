module Cmor
  module Cms
    class PartialResolver < ::ActionView::Resolver
      require "singleton"
      include Singleton

      # add shared behaviour for database backed templates
      include Cmor::Cms::DatabaseResolver

      def template_class
        "Cmor::Cms::Partial"
      end

      def build_source(record)
        record.body
      end

      def normalize_basename(basename)
        "_" << basename
      end

      def resolve(partial_flag)
        partial_flag
      end
    end
  end
end
