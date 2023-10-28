require "rails_helper"

RSpec.describe Cmor::UserArea::Engine do
  describe "settings" do
    it { expect(Cmor::Core::Settings.get("cmor_user_area/user.enable_registrations")).to eq(false) }
    it { expect(Cmor::Core::Settings.get("cmor_user_area/user.allow_users_to_destroy_self")).to eq(false) }
    it { expect(Cmor::Core::Settings.get("cmor_user_area/user_mailer.application_name")).to eq("Application") }
    it { expect(Cmor::Core::Settings.get("cmor_user_area/user_mailer.sender")).to eq(nil) }
    it { expect(Cmor::Core::Settings.get("cmor_user_area/tfa.enable")).to eq(false) }
  end
end
