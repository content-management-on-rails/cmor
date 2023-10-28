Rails.application.config.to_prepare do
  Cmor::Core::Settings.configure do |config|
    config.register(
      namespace: :cmor_contact,
      key: "contact_request.sender",
      type: :string,
      default: nil,
      validations: {presence: true}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.subject.application_name",
      type: :string,
      default: nil,
      validations: {presence: true}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.recipients",
      type: :array,
      default: nil,
      validations: {presence: true, format: {with: /.*@.*/}}
    )

    config.register(
      namespace: :cmor_contact,
      key: "whatsapp.number",
      type: :string,
      default: nil,
      validations: {presence: true, format: {with: /\A\+[\d\s]+\z/}}
    )
  end
end
