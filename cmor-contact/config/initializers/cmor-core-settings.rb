Rails.application.config.to_prepare do
  Cmor::Core::Settings::Settable.create!(
    namespace: :cmor_contact,
    key: "contact_request.sender",
    default: nil,
    validations: {presence: true}
  )

  Cmor::Core::Settings::Settable.create!(
    namespace: :cmor_contact,
    key: "contact_request.subject.application_name",
    default: nil,
    validations: {presence: true}
  )

  Cmor::Core::Settings::Settable.create!(
    namespace: :cmor_contact,
    key: "contact_request.recipients",
    default: nil,
    validations: {presence: true, format: {with: /.*@.*/}}
  )

  Cmor::Core::Settings::Settable.create!(
    namespace: :cmor_contact,
    key: "whatsapp.number",
    default: nil,
    validations: {presence: true, format: {with: /\A\+[\d\s]+\z/}}
  )
end
