module Cmor::Core::Settings
  class SettingsController < Cmor::Core::Backend::ResourcesController::Base
    include Rao::Query::Controller::QueryConcern

    def self.resource_class
      Cmor::Core::Settings::Setting
    end

    def self.available_rest_actions
      super - %i(new create destroy)
    end

    private

    def load_collection_scope
      with_conditions_from_query(super)
    end

    def permitted_params
      params.require(:setting).permit(:value)
    end
  end
end
