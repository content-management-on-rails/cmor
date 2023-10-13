require "spec_helper"

RSpec.describe Cmor do
  it { expect(described_class).to be_const_defined(:VERSION) }
end
