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

# Setup Webpacker
sed -i '17i\require "webpacker"' config/application.rb
rails webpacker:install

# Setup SimpleForm
rails generate simple_form:install --bootstrap

# Setup i18n
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# Setup i18n routing
touch config/initializers/route_translator.rb
echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
echo "  config.force_locale = true" >> config/initializers/route_translator.rb
echo "end" >> config/initializers/route_translator.rb

# Setup administrador
rails generate administrador:install

# Setup cmor-core
rails generate cmor:core:install

# Setup cmor-core-backend
rails generate cmor:core:backend:install

# Setup cmor-core-settings
rails cmor_core_settings:install:migrations
rails generate cmor:core:settings:install

# Setup cmor-contact
rails cmor_contact:install:migrations
rails generate cmor:contact:install

# Setup database
rails db:migrate db:test:prepare
