FactoryBot.define do
  factory :cmor_core_settings_settable, class: Cmor::Core::Settings::Settable do
    sequence(:namespace) { |i| "namespace-#{i}" }
    sequence(:key) { |i| "key-#{i}" }
  end
end
