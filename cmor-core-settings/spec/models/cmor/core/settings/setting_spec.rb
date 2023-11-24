require "rails_helper"

RSpec.describe Cmor::Core::Settings::Setting, type: :model do
  around(:each) do |example|
    settings = Cmor::Core::Settings::Setting.all
    Cmor::Core::Settings::Setting.delete_all
    example.run
    settings.map(&:save!)
  end

  describe "validations" do
    subject { build(:cmor_core_settings_setting) }

    describe "type" do
      it { expect(subject).to validate_presence_of(:type) }
      it { expect(subject).to validate_inclusion_of(:type).in_array([:array, :boolean, :hash, :integer, :password, :string]) }
    end
  end

  describe "class methods" do
    subject { described_class }

    describe "#create!" do
      it "registers a setting" do
        expect { subject.create!(namespace: :cmor_core_backend, key: :foo, type: :string, default: "bar") }.to change { Cmor::Core::Settings::Setting.count }.by(1)
      end
    end

    describe "#all" do
      it { expect(subject.all).to be_a(ActiveRecord::Relation) }
    end

    describe "#find_by_namespace_and_key" do
      before(:each) { create(:cmor_core_settings_setting, namespace: :cmor_core_backend, key: :foo, type: :string, default: "bar") }

      it { expect(subject.where(namespace: :cmor_core_backend, key: :foo).first).to be_a(Cmor::Core::Settings::Setting) }
    end
  end

  describe "#value" do
    it { expect(subject).to respond_to(:value) }

    describe "when setting exists" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :string, default: "bar") }

      before(:each) { subject.value_content = "baz"; subject.value.save! }

      it { expect(subject.value_content).to eq("baz") }
    end

    describe "when default" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :string, default: "bar") }

      it { expect(subject.value_content).to eq("bar") }
    end
  end

  describe "type casting" do
    describe "when type is :array" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :array) }

      describe "when passing an array" do
        before(:each) { subject.value_content = ["foo", "bar"]; subject.save! }

        it { expect(subject.value_content).to eq(["foo", "bar"]) }
      end

      describe "when passing a string" do
        before(:each) { subject.value_content = "foo,bar"; subject.save! }

        it { expect(subject.value_content).to eq(["foo", "bar"]) }
      end
    end

    describe "when type is :boolean" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :boolean)}

      describe "when passing a boolean" do
        before(:each) { subject.value_content = true; subject.value.save! }

        it { expect(subject.value_content).to eq(true) }
      end

      describe "when passing a string" do
        before(:each) { subject.value_content = "true"; subject.value.save! }

        it { expect(subject.value_content).to eq(true) }
      end

      describe "when passing an integer" do
        before(:each) { subject.value_content = 1; subject.value.save! }

        it { expect(subject.value_content).to eq(true) }
      end
    end

    describe "when type is :hash" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :hash)}

      describe "when passing a hash" do
        before(:each) { subject.value_content = { foo: "bar" }; subject.value.save! }

        it { expect(subject.value_content).to eq({ foo: "bar" }) }
      end

      describe "when passing a string" do
        before(:each) { subject.value_content = { foo: "bar" }.to_json; subject.value.save! }

        it { expect(subject.value_content).to eq({ foo: "bar" }) }
      end
    end

    describe "when type is :string" do
      subject { described_class.new(namespace: :cmor_core_backend, key: :foo, type: :string)}

      describe "when passing a string" do
        before(:each) { subject.value_content = "foo"; subject.value.save! }

        it { expect(subject.value_content).to eq("foo") }
      end

      describe "when passing an integer" do
        before(:each) { subject.value_content = 1; subject.value.save! }

        it { expect(subject.value_content).to eq("1") }
      end

      describe "when passing a symbol" do
        before(:each) { subject.value_content = :foo; subject.value.save! }

        it { expect(subject.value_content).to eq("foo") }
      end
    end
  end
end
