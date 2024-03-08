module Cmor
  module Core
    module Api
      module ServiceResult
        module Serializer
          class Base
            def initialize(result, options = {})
            @result = result
            @options = options.reverse_merge(full_messages: true)
            end

            def as_json
              @result.as_json(except: ['service']).merge(
                meta: serialize_meta(@result)
              )
            end

            def serialize_errors(result)
              # return nil if result.errors.none?
              result.errors.as_json(full_messages: @options[:full_messages])
            end

            def serialize_messages(result)
              result.messages.as_json
            end

            def serialize_meta(result)
              {
                messages: serialize_messages(@result),
                attribute_names: @result.service.class.attribute_names.each_with_object({}) { |an, memo| memo[an] = @result.service.class.human_attribute_name(an)  },
                service_class: @result.service.class.name,
                service_name: @result.service.class.model_name.human
              }
            end
          end
        end
      end
    end
  end
end
