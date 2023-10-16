FactoryBot.define do
  factory :cmor_core_settings_setting, class: Cmor::Core::Settings::Setting do
    sequence(:namespace) { |i| "namespace-#{i}" }
    sequence(:key) { |i| "key-#{i}" }
  end
end
