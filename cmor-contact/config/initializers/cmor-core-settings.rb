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

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.user_name",
      type: :string,
      default: nil,
      validations: {}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.password",
      type: :password,
      default: nil,
      validations: {}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.address",
      type: :string,
      default: nil,
      validations: {}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.port",
      type: :integer,
      default: 587,
      validations: {numericality: {only_integer: true, greater_than: 0, less_than: 65536}}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.authentication",
      type: :string,
      default: "plain",
      validations: {inclusion: {in: %w[plain login cram_md5]}}
    )

    config.register(
      namespace: :cmor_contact,
      key: "contact_request.smtp.enable_starttls_auto",
      type: :boolean,
      default: true,
      validations: {inclusion: {in: %w[true false]}}
    )
  end
end
