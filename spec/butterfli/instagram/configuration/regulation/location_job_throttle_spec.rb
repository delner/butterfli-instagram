require 'spec_helper'

describe Butterfli::Instagram::Configuration::Regulation::LocationJobThrottle do
  let(:args) { { obj_id: 1 } }
  let(:max) { 400 }
  let(:interval) { 3600 }
  before(:each) do
    configure_for_instagram do |provider|
      provider.policy :jobs do |jobs|
        jobs.throttle :location do |t|
          t.matching args
          t.limit max
          t.per_seconds interval
        end
      end
    end
  end
  subject { Butterfli.configuration.providers(:instagram).policies(:jobs).rules }
  it do
    expect(subject).to_not be_empty
    expect(subject.first).to be_a_kind_of(Butterfli::Instagram::Configuration::Regulation::LocationJobThrottle)
    expect(subject.first.max).to eq(max)
    expect(subject.first.interval).to eq(interval)
    expect(subject.first.args).to eq(args)
  end
end