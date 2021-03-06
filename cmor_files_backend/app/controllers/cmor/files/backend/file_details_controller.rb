module Cmor
  module Files
    module Backend
      class FileDetailsController < Cmor::Core::Backend::ResourcesController::Base
        include Rao::ResourcesController::ActsAsListConcern
        include Rao::ResourcesController::ActsAsPublishedConcern
        include Rao::ResourcesController::FriendlyIdConcern

        def self.resource_class
          Cmor::Files::FileDetail
        end

        def self.available_rest_actions
          super - [:new, :create]
        end

        private

        def load_collection_scope
          super.joins(:folder)
        end

        def permitted_params
          params.require(:file_detail).permit(:title, :description)
        end
      end
    end
  end
end
