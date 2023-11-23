require "rails_helper"

RSpec.describe Cmor::Core::Settings do
  around(:each) do |example|
    settings = Cmor::Core::Settings::Setting.all
    Cmor::Core::Settings::Setting.delete_all
    example.run
    Cmor::Core::Settings::Setting.instance_variable_set(:@all, settings)
  end
  
  describe "class methods" do
    subject { described_class }
    
    describe "#get" do
      it { expect(subject).to respond_to(:get) }

      describe "when setting exists" do
        let(:setting) { Cmor::Core::Settings::Setting.create!(namespace: :cmor_core_backend, key: :foo, type: :string, default: "bar") }

        before(:each) { setting }

        it { expect(subject.get(:cmor_core_backend, :foo)).to eq("bar") }
      end
    end
    
    describe "#set" do
      it { expect(subject).to respond_to(:set) }

      describe "persistence changes" do
        let(:settable) { Cmor::Core::Settings::Setting.create!(namespace: :cmor_core_backend, key: :foo, type: :string, default: nil) }

        before(:each) { settable }
        
        it { expect{ subject.set(:cmor_core_backend, :foo, "baz") }.to change { subject.get(:cmor_core_backend, :foo) }.from(nil).to("baz") }
      end
    end
  end
end