module Cmor
  module MultiTenancy
    module Job
      module ClientConcern
        extend ActiveSupport::Concern

        included do
          # set current client when enqueuing jobs
          before_enqueue do |job|
            unless job.arguments.last.is_a?(Hash) && job.arguments.last.key?(:current_client)
              job.arguments << { current_client: Cmor::MultiTenancy.current_client }
            end
          end

          # set current client when performing jobs
          around_perform do |job, block|
            current_client = job.arguments.last.delete(:current_client)
            job.arguments.pop if job.arguments.last.empty?

            Cmor::MultiTenancy.with_client(current_client) do
              block.call
            end
          end
        end
      end
    end
  end
end
