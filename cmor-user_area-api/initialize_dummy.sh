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

# Always require rspec and factory_bot_rails in dummy app
sed -i '17i\  require "rspec-rails"' config/application.rb
sed -i '17i\  require "factory_bot_rails"' config/application.rb

# Setup i18n
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# Setup ActiveStorage
rails active_storage:install:migrations

# Setup ActiveRecord encryption
sed -i '/end/i\  config.active_record.encryption.primary_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.deterministic_key = "test"' config/environments/test.rb
sed -i '/end/i\  config.active_record.encryption.key_derivation_salt = "test"' config/environments/test.rb

# Setup cmor-core-api
rails generate cmor:core:api:install
rails cmor_core_api:install:migrations

# Setup cmor-user_area
rails generate cmor:user_area:install
rails cmor_user_area:install:migrations

# Setup cmor-user_area-api
BASE_CONTROLLER_CLASS_NAME=ApiController rails generate cmor:user_area:api:install

# Setup api authentication
touch app/controllers/api_controller.rb
echo "class ApiController < ActionController::API" >> app/controllers/api_controller.rb
echo "  include Cmor::Core::Api::Controllers::TokenAuthenticationConcern" >> app/controllers/api_controller.rb
echo "  before_action :authenticate_with_token!" >> app/controllers/api_controller.rb
echo "end" >> app/controllers/api_controller.rb

# Setup database
rails db:migrate db:test:prepare

# Setup unpermitted params
sed -i '/end/i\  config.action_controller.action_on_unpermitted_parameters = :raise' config/environments/test.rb
