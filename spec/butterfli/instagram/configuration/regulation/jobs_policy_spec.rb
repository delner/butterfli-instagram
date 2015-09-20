require 'spec_helper'

describe Butterfli::Instagram::Configuration::Regulation::JobsPolicy do
  let(:args) { { obj_id: 1 } }
  let(:max) { 400 }
  let(:interval) { 3600 }
  before(:each) do
    configure_for_instagram do |provider|
      provider.policy :jobs do nil end
    end
  end
  subject { Butterfli.configuration.providers(:instagram).policies }
  it do
    expect(subject).to_not be_empty
    expect(subject.first).to include(:jobs, Butterfli::Instagram::Configuration::Regulation::JobsPolicy)
  end
end