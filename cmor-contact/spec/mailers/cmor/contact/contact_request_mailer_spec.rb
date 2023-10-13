require "rails_helper"

RSpec.describe Cmor::Contact::ContactRequestMailer, type: :mailer do
  describe "notify" do
    let(:contact_request) { create(:cmor_contact_contact_request) }

    subject { described_class.notify(contact_request) }

    describe "body" do
      Cmor::Contact::ContactRequest.attribute_names.each do |attribute|
        it { expect(subject.body.encoded).to include(contact_request.class.human_attribute_name(attribute)) }
        it { expect(subject.body.encoded).to include(contact_request.send(attribute).to_s) }
      end
    end

    describe "subject" do
      let(:application_name) { "Dummy" }
      let(:mail_subject) { "[#{application_name}] Neue Kontaktanfrage" }

      before(:each) { Cmor::Core::Settings.set(:cmor_contact, "contact_request.subject.application_name", application_name) }

      it { expect(subject.subject).to eq(mail_subject) }
    end

    describe "recipient" do
      let(:recipient) { "jane.doe@domain.local" }

      before(:each) { Cmor::Core::Settings.set(:cmor_contact, "contact_request.recipients", recipient) }

      it { expect(subject.to).to eq([recipient]) }
    end

    describe "sender" do
      let(:sender) { "john.smith@domain.local" }

      before(:each) { Cmor::Core::Settings.set(:cmor_contact, "contact_request.sender", sender) }

      it { expect(subject.from).to eq([sender]) }
    end
  end
end
