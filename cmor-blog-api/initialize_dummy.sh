#!/bin/bash

# delete old dummy app
rm -rf spec/dummy

# generate new dummy app
DISABLE_MIGRATE=true bundle exec rake dummy:app

if [ ! -d "spec/dummy/config" ]; then exit 1; fi

# cleanup
rm spec/dummy/.ruby-version
rm spec/dummy/Gemfile

cd spec/dummy

# Use correct Gemfile
sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Setup Webpacker
rails webpacker:install

# Setup SimpleForm
rails generate simple_form:install --bootstrap

## Always require rspec and factory_bot_rails in dummy app
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

# setup User model for userstamping
rails g model User email
sed -i '2i\  private' app/controllers/application_controller.rb
sed -i '3i\  ' app/controllers/application_controller.rb
sed -i '4i\  def current_user' app/controllers/application_controller.rb
sed -i '5i\    User.first_or_create!(email: "jane.doe@domain.local")' app/controllers/application_controller.rb
sed -i '6i\  end' app/controllers/application_controller.rb

# Setup cmor-core-api
rails generate cmor:core:api:install
rails cmor_core_api:install:migrations

# Setup cmor-blog
rails generate cmor:blog:install
rails cmor_blog:install:migrations

# Setup cmor-blog-api
BASE_CONTROLLER_CLASS_NAME=ApiController rails generate cmor:blog:api:install

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
