module Cmor::Contact
  class WhatsappRequest
    include ActiveModel::Model

    attr_accessor :message

    validates :message, presence: true

    def whatsapp_link
      "https://wa.me/#{number_for_url}?text=#{encoded_message}"
    end

    def number_for_url
      Cmor::Core::Settings.get(:cmor_contact, "whatsapp.number")&.delete("+")&.delete(" ")
    end

    private

    def encoded_message
      if URI.respond_to?(:encode)
        URI.encode(message)
      else
        CGI.escape(message)
      end
    end
  end
end
