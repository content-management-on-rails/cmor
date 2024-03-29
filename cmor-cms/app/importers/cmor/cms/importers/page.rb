module Cmor
  module Cms
    module Importers
      class Page
        def initialize(yaml, _option = {})
          @pages = nil
          @yaml = YAML.safe_load(yaml)
        end

        def build_pages
          pages = []
          if @yaml.respond_to?(:each)
            @yaml.each do |page_data|
              navigation_items = extract_navigation_items(page_data.delete("navigation_items"))
              page = Cmor::Cms::Page.new(page_data)
              page.navigation_item_ids = navigation_items.map(&:id)
              pages << page
            end
          end
          pages
        end

        def extract_navigation_items(navigation_item_data)
          navigation_items = []
          navigation_item_data.each do |nid|
            navigation = Cmor::Cms::Navigation.where(locale: nid["navigation_locale"], name: nid["navigation_name"]).first
            navigation_items << navigation.navigation_items.where(name: nid["name"]).first if navigation.respond_to?(:navigation_items)
          end
          navigation_items
        end

        def pages
          @pages ||= build_pages
        end

        attr_reader :yaml
      end
    end
  end
end
