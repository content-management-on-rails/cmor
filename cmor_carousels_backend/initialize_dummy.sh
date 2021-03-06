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

# responders for rao-service_controller
## Always require rspec and factory_bot_rails in dummy app
required_gems="require 'responders'\nrequire 'rspec-rails'\nrequire 'factory_bot_rails'\n"
echo "$(awk 'NR==17{print "'"$required_gems"'"}1' config/application.rb)" > config/application.rb

## I18n configuration
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

## I18n routing
touch config/initializers/route_translator.rb
echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
echo "  config.force_locale = true" >> config/initializers/route_translator.rb
echo "end" >> config/initializers/route_translator.rb

# Add ActiveStorage
rails active_storage:install

# Install simple form
rails generate simple_form:install --bootstrap

# Install cmor core backend gem
rails generate administrador:install
rails generate cmor:core:backend:install

# CMOR Carousels
rails generate cmor:carousels:install
rails cmor_carousels:install:migrations db:migrate db:test:prepare

# Install
rails generate cmor:carousels:backend:install