#!/bin/bash

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
DISABLE_MIGRATE=true bundle exec rake dummy:app

if [ ! -d "spec/dummy/config" ]; then exit 1; fi

# Cleanup
rm spec/dummy/.ruby-version
rm spec/dummy/Gemfile

cd spec/dummy

# Use correct Gemfile
sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Add webpacker
sed -i '17i\  require "webpacker"' config/application.rb
rails webpacker:install

# I18n configuration
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# I18n routing
touch config/initializers/route_translator.rb
echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
echo "  config.force_locale = true" >> config/initializers/route_translator.rb
echo "end" >> config/initializers/route_translator.rb

# Add ActiveStorage
# rails active_storage:install

# Add FrontendController needed by Cmor::Cms::PageController
touch app/controllers/frontend_controller.rb
echo "class FrontendController < ApplicationController" >> app/controllers/frontend_controller.rb
echo "end" >> app/controllers/frontend_controller.rb

# Add controller needed for template rendering specs
touch app/controllers/page_test_controller.rb
echo "class PageTestController < ApplicationController" >> app/controllers/page_test_controller.rb
echo "  include Cmor::Cms::ControllerExtensions::PageResolver" >> app/controllers/page_test_controller.rb
echo "  def index; end" >> app/controllers/page_test_controller.rb
echo "end" >> app/controllers/page_test_controller.rb
sed -i '2i\  localized { get "page_test", to: "page_test#index" }' config/routes.rb

# Add controller needed for partial rendering specs
touch app/controllers/partial_test_controller.rb
echo "class PartialTestController < ApplicationController" >> app/controllers/partial_test_controller.rb
echo "  include Cmor::Cms::ControllerExtensions::PageResolver" >> app/controllers/partial_test_controller.rb
echo "  include Cmor::Cms::ControllerExtensions::PartialResolver" >> app/controllers/partial_test_controller.rb
echo "  def index; end" >> app/controllers/partial_test_controller.rb
echo "end" >> app/controllers/partial_test_controller.rb
sed -i '2i\  localized { get "partial_test", to: "partial_test#index" }' config/routes.rb

# Add yield for context block spec
sed -i '14i\  <%= yield :sidebar %>' app/views/layouts/application.html.erb

# Add cms helper for title/meta description spec
sed -i '2i\  view_helper Cmor::Cms::ApplicationViewHelper, as: :cms_helper' app/controllers/application_controller.rb
sed -i "s|<title>.*</title>|<title><%= cms_helper(self).title %></title>|" app/views/layouts/application.html.erb
sed -i '7i\    <%= cms_helper(self).meta_description.html_safe %>' app/views/layouts/application.html.erb

# Install
rails cmor_cms:install:migrations db:migrate db:test:prepare
rails generate cmor:cms:install
