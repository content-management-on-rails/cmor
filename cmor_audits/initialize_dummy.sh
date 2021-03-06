#!/bin/bash

DUMMY_APP_PATH="spec/dummy"

# Delete old dummy app
if [ -d "$DUMMY_APP_PATH" ]; then rm -rf $DUMMY_APP_PATH; fi

# Generate new dummy app
DUMMY_APP_PATH=$DUMMY_APP_PATH DISABLE_MIGRATE=true bundle exec rake dummy:app

if [ ! -d "$DUMMY_APP_PATH/config" ]; then exit 1; fi

rm $DUMMY_APP_PATH/.ruby-version
rm $DUMMY_APP_PATH/Gemfile

cd $DUMMY_APP_PATH

# Use correct Gemfile
sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Add ActiveStorage
rails active_storage:install

# I18n configuration
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# I18n routing
touch config/initializers/route_translator.rb
echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
echo "  config.force_locale = true" >> config/initializers/route_translator.rb
echo "end" >> config/initializers/route_translator.rb

# Add turbolinks
sed -i "15irequire 'turbolinks'" config/application.rb
sed -i "16irequire 'factory_bot_rails'" config/application.rb

# Install administrador
rails generate administrador:install

# Install SimpleForm
rails generate simple_form:install --bootstrap

# Install cmor_core_backend
rails g cmor:core:backend:install

# Install paper trail
rails g paper_trail:install

# Setup specs
rails g model User email
rails g factory_bot:model User email
sed -i "17irequire 'cmor_blog'" config/application.rb
sed -i "18irequire 'cmor_blog_backend'" config/application.rb
rails g cmor:core:install
rails g cmor:blog:install
rails g cmor:blog:backend:install
rails cmor_blog:install:migrations
sed -i "2i  config.enable_feature(:cmor_audits, {})" config/initializers/cmor_core.rb

# Install
rails generate cmor:audits:install
rails db:migrate db:test:prepare
sed -i "s/  config.resources = -> { {} }/  config.resources = -> { { \"Cmor::Blog::Post\" => {} } }/g" config/initializers/cmor_audits.rb
