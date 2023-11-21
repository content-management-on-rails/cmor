module Cmor::Contact
  class ContactRequestMailer < ApplicationMailer
    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.cmor.cmor_contact.contact_request_mailer.notify.subject
    #
    def notify(contact_request)
      @contact_request = contact_request

      mail to: notification_recipients,
        from: notification_sender,
        subject: notification_subject,
        delivery_method_options: delivery_method_options.call
    end

    private

    def delivery_method_options
      lambda do
        {
          user_name: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.user_name"),
          password: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.password"),
          address: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.address"),
          port: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.port"),
          authentication: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.authentication"),
          enable_starttls_auto: Cmor::Core::Settings.get(:cmor_contact, "contact_request.smtp.enable_starttls_auto")
        }
      end
    end

    def notification_subject
      # default_i18n_subject(application_name: Rails.application.class.to_s.split("::").first.underscore.humanize.titleize)
      default_i18n_subject(application_name: Cmor::Core::Settings.get(:cmor_contact, "contact_request.subject.application_name"))
    end

    def notification_sender
      Cmor::Core::Settings.get(:cmor_contact, "contact_request.sender")
    end

    def notification_recipients
      Cmor::Core::Settings.get(:cmor_contact, "contact_request.recipients")
    end
  end
end
