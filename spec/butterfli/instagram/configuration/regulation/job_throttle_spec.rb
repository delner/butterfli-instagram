require 'spec_helper'

describe Butterfli::Instagram::Configuration::Regulation::JobThrottle do
  let(:job_throttle_config_class) do
    stub_const 'TestJobThrottleConfig', Class.new(Butterfli::Instagram::Configuration::Regulation::JobThrottle)
    TestJobThrottleConfig.class_eval do
      def last_time_key; nil end
      def self.job_class; nil end
    end
    TestJobThrottleConfig
  end
  let(:job_throttle_config) { job_throttle_config_class.new }

  context "when initialized" do
    subject { job_throttle_config }
    it { expect(subject.args).to be_empty }
  end
  describe "#matching" do
    subject { job_throttle_config.matching args }
    context "when provided a list of arguments" do
      let(:args) { double('args') }
      it { subject; expect(job_throttle_config.args).to eq(args) }
    end
  end
  describe "#instantiate" do
    subject { job_throttle_config.instantiate }
    let(:type) { double('type') }
    let(:args) { double('args') }
    let(:last_time_key) { double('last_time_key') }
    before(:each) do
      job_throttle_config.matching args
      allow(job_throttle_config).to receive(:last_time_key).and_return(last_time_key)
      allow(job_throttle_config.class).to receive(:job_class).and_return(type)
    end
    it { expect(subject).to be_a_kind_of(Butterfli::Instagram::Regulation::JobThrottle) }
    it { expect(subject.type).to eq(type) }
    it { expect(subject.args).to eq(args) }
    it { expect(subject.last_time_key).to eq(last_time_key) }
  end
end