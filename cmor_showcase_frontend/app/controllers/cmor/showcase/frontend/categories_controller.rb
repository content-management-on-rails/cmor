module Cmor::Showcase::Frontend
  class CategoriesController < Cmor::Showcase::Frontend::Configuration.base_controller.constantize
    include Rao::ResourcesController::RestActionsConcern
    include Rao::ResourcesController::ResourcesConcern
    include Rao::ResourcesController::RestResourceUrlsConcern
    include Rao::ResourcesController::ResourceInflectionsConcern
    include Rao::ResourcesController::FriendlyIdConcern

    view_helper Markup::Rails::ApplicationViewHelper, as: :markup_helper

    def self.resource_class
      Cmor::Showcase::Category
    end

    private

    def permitted_params
      params.require(:category).permit()
    end
  end
end