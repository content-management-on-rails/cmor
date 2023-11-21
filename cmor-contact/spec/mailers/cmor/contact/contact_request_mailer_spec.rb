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

    describe "delivery method options" do
      describe "cmor_contact/contact_request.smtp.address" do
        before(:each) do
          expect(Cmor::Core::Settings).to receive(:get).with(:cmor_contact, "contact_request.smtp.address").and_return("smtp.example.com")
          allow(Cmor::Core::Settings).to receive(:get).and_call_original
        end

        it { expect(subject.delivery_method.settings[:address]).to eq("smtp.example.com") }
      end
    end
  end
end
