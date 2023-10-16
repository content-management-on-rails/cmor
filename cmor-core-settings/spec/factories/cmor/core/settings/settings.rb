FactoryBot.define do
  factory :cmor_core_settings_value, class: Cmor::Core::Settings::Value do
    namespace { "Foo::Bar" }
    sequence(:key) { |i| "key-#{i}" }
  end
end
