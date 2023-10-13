require "rails_helper"

RSpec.describe Cmor::Contact::WhatsappRequest, type: :model do
  describe "number_for_url" do
    let(:whatsapp_number) { "+49 123 456789" }
    let(:number_for_url) { "49123456789" }

    before(:each) { Cmor::Core::Settings.set(:cmor_contact, "whatsapp.number", whatsapp_number) }

    it { expect(subject.number_for_url).to eq(number_for_url) }
  end
end
