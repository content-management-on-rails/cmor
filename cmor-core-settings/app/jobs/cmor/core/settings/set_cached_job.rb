module Cmor
  module Core
    module Settings
      class SetCachedJob < ApplicationJob
        queue_as :default

        def perform(*args)
          Cmor::Core::Settings.delayed.run!
        end
      end
    end
  end
end
