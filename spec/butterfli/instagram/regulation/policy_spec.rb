require 'spec_helper'

describe Butterfli::Instagram::Regulation::JobsPolicy do
  it { expect(Butterfli::Instagram::Regulation::JobsPolicy <= Butterfli::Regulation::Policy).to be true }
end