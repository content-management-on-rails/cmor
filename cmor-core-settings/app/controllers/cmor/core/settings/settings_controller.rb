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
      super.eager_load(:values)
    end

    def permitted_params
      if @resource.type == "array"
        params.require(:setting).permit(values_attributes: [:_destroy, :id, :content])
      else
        params.require(:setting).permit(value_attributes: [:_destroy, :id, :content])
      end
    end
  end
end
