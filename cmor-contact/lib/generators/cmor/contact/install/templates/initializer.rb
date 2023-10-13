Cmor::Contact.configure do |config|
  # Register self to be shown in the backend.
  #
  # Default: config.register_engine("Cmor::Contact::Engine", {})
  #
  config.cmor.administrador.register_engine("Cmor::Contact::Engine", {})

  # Set the resources, that will be shown in the backend menu.
  #
  # Default: config.resources_controllers = -> {[
  #            Cmor::Contact::ContactRequestsController
  #          ]}
  #
  config.resources_controllers = lambda {
    [
      Cmor::Contact::ContactRequestsController
    ]
  }

  # Set the services, that will be shown in the backend menu.
  #
  # Default: config.service_controllers = -> {[
  #          ]}
  #
  config.service_controllers = lambda {
    []
  }

  # Modules listed here will be included in Cmor::Contact::ContactRequest.
  #
  # Available modules are:
  #
  # - Cmor::Contact::ContactRequest::PhoneConcern
  # - Cmor::Contact::ContactRequest::SubjectConcern
  #
  # Default: config.contact_request_include_modules = ->() { [Cmor::Contact::ContactRequest::PhoneConcern] }
  #
  config.contact_request_include_modules = -> { [Cmor::Contact::ContactRequest::PhoneConcern] }
end
