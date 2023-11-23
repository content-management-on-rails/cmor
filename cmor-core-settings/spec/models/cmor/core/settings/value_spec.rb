require 'rails_helper'

module Cmor::Core::Settings
  RSpec.describe Value, type: :model do
    describe "validations" do
      subject { build(:cmor_core_settings_value) }
      # it { expect(subject).to validate_presence_of(:namespace) }
      # it { expect(subject).to validate_presence_of(:key) }
      # it { expect(subject).to validate_uniqueness_of(:key).scoped_to(:namespace) }
    end

    describe "dynamic validations" do
      describe "presence" do
        let(:setting) { Value.new(namespace: "Cmor::Contact", key: "contact_request.sender", validations: { presence: true }) }

        it { expect(setting).to validate_presence_of(:content) }
      end

      describe "format" do
        let(:setting) { Setting.new(namespace: "Cmor::Contact", key: "contact_request.sender", validations: { format: { with: /.*@.*/ } }) }

        # it { expect(setting).not_to allow_value("foo").for(:value) }
      end

      describe "content serialization" do
        describe "for arrays" do
          subject { described_class.new }

          before(:each) { subject.content = ["foo", "bar"] }

          it { expect(subject.content).to eq(["foo", "bar"]) }
        end
      end
    end
  end
end
