module Cmor
  module Core
    module Api
      module ServiceController
        module SerializationConcern
          extend ActiveSupport::Concern

          class_methods do
            def serializer_class; end
          end

          private

          def serialize_result(service_result)
            serialize_service_result(service_result)
          end

          def serialize_attribute_names(service_result)
            service_result.service.class.attribute_names.each_with_object({}) do |an, memo|
              memo[an] = service_result.service.class.human_attribute_name(an)
            end
          end

          def serialize_errors(service_result, full_messages: true)
            service_result.errors.as_json(full_messages: full_messages)
          end

          def serialize_messages(service_result)
            service_result.messages.as_json
          end

          def serialize_service_class(service_result)
            service_result.service.class.name
          end

          def serialize_service_name(service_result)
            service_result.service.class.model_name.human
          end

          def serialize_service_result(service_result)
            {}.tap do |json|
              if serializable_object(service_result).is_a?(Rao::Service::Result::Base)
                json[:data] = serializable_object(service_result).as_json(except: ['service'])
              else
                json[:data] = serializable_object(service_result).as_json
              end
              json[:errors] = serialize_errors(service_result) # if service_result.errors.any?
              json[:meta] = {
                attribute_names: serialize_attribute_names(service_result),
                messages: serialize_messages(service_result),
                service_class: serialize_service_class(service_result),
                service_name: serialize_service_name(service_result)
              }
            end
          end

          def serializable_object(service_result)
            if self.class.serializer_class.present?
              self.class.serializer_class.new(service_result, params.permit!.to_h)
            else
              service_result
            end
          end
        end
      end
    end
  end
end
