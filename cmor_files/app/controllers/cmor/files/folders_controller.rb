module Cmor::Files
  class FoldersController < ApplicationResourcesController
    include Rao::ResourcesController::FriendlyIdConcern

    helper Rao::Component::ApplicationHelper

    def self.resource_class
      Cmor::Files::Folder
    end

    private

    def load_collection_scope
      super.published
    end

    def load_resource_scope
      super.published
    end
  end
end
