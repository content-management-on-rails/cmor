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

# Setup ActiveRecord encryption
sed -i '/end/i\  config.active_record.encryption.primary_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.deterministic_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.key_derivation_salt = "test"' config/environments/test.rb

# Setup ActiveStorage
rails active_storage:install

# setup Administrador
rails generate administrador:install

# Setup Cmor::Core
rails generate cmor:core:install

# Setup Cmor::Core::Settings
rails generate cmor:core:settings:install
rails cmor_core_settings:install:migrations

# Setup database
rails db:migrate && rails db:test:prepare
