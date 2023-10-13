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
# sed -i '17i\  require "responders"' config/application.rb

# Always require rspec and factory_bot_rails in dummy app
sed -i '17i\  require "rspec-rails"' config/application.rb
sed -i '17i\  require "factory_bot_rails"' config/application.rb

# I18n configuration
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# I18n routing
# touch config/initializers/route_translator.rb
# echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
# echo "  config.force_locale = true" >> config/initializers/route_translator.rb
# echo "end" >> config/initializers/route_translator.rb

# Install Administrador
rails generate administrador:install

# Install SimpleForm
rails generate simple_form:install --bootstrap

# Add DelayedJob::ActiveRecord
# sed -i '17i\  require "delayed_job_active_record"' config/application.rb
# rails generate delayed_job:active_record

# Add ActiveStorage
# rails active_storage:install

# Setup ActiveRecord encryption
sed -i '/end/i\  config.active_record.encryption.primary_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.deterministic_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.key_derivation_salt = "test"' config/environments/test.rb

# Example model for ActiveStorage specs
# rails g model Post title

# Install cmor-core-backend
rails generate cmor:core:backend:install

# Setup database
# rails db:migrate db:test:prepare

# Setup unpermitted params
sed -i '/end/i\  config.action_controller.action_on_unpermitted_parameters = :raise' config/environments/test.rb
