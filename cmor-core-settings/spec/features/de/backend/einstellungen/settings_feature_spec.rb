require "rails_helper"

RSpec.describe "/de/backend/einstellungen/settings", type: :feature do
  let(:resource_class) { Cmor::Core::Settings::Setting }

  describe "REST actions" do
    let(:resource) { create(:cmor_core_settings_setting) }
    let(:resources) { create_list(:cmor_core_settings_setting, 3) }

    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_setting") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     fill_in 'slider[name]', with: 'New name'
          fill_in "setting[value]", with: "This is the new value"
        }
        .updating
        .from(resource.attributes)
        .to({"value" => "This is the new value"}) # Example: .to({ 'name' => 'New name' })
    }
  end
end
