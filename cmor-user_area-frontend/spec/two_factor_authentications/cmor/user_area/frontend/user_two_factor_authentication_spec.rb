require "rails_helper"

RSpec.describe Cmor::UserArea::Frontend::UserTwoFactorAuthentication, type: :service do
  describe "basic usage" do
    let(:user) { create(:cmor_user_area_user) }
    let(:otp_code) { "some-code" }
    let(:attributes) { {authenticable: user, code: otp_code} }
    subject { described_class.new(attributes) }

    it { expect(subject).to be_a(Rao::Service::Base) }

    it { expect(subject.perform).to be_a(Rao::Service::Result::Base) }

    describe "with an invalid backup code" do
      let(:otp_code) { "invalid" }

      describe "result" do
        it { expect(subject.perform).not_to be_ok }
        it { expect(subject.errors.full_messages).to match_array([]) }
      end
    end

    describe "with a valid backup code" do
      let(:otp_code) { user.otp_backup_codes.first }

      describe "result" do
        it { expect(subject.perform).to be_ok }
        it { expect(subject.errors.full_messages).to match_array([]) }
      end

      describe "persistence changes" do
        it { expect { subject.perform }.to change { user.reload.otp_backup_codes.count }.by(-1) }
      end
    end
  end
end
