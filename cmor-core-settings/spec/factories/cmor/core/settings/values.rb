FactoryBot.define do
  factory :cmor_core_settings_value, class: Cmor::Core::Settings::Value do
    association(:setting, factory: :cmor_core_settings_setting)
    namespace { "Foo::Bar" }
    sequence(:key) { |i| "key-#{i}" }
  end
end
