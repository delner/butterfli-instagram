require 'spec_helper'

describe Butterfli::Instagram::Regulation::JobThrottle do
  let(:options) { { } }
  let(:job_throttle) { Butterfli::Instagram::Regulation::JobThrottle.new(options) }
  context "when initialized" do
    subject { job_throttle }
    context "with no options" do
      it { expect(subject.args).to be_empty }
    end
    context "with a type" do
      let(:type) { double('type') }
      let(:options) { { type: type } }
      it { expect(subject.type).to eq(type) }
    end
    context "with a last_time_key" do
      let(:last_time_key) { double('last_time_key') }
      let(:options) { { last_time_key: last_time_key } }
      it { expect(subject.last_time_key).to eq(last_time_key) }
    end
    context "with args" do
      let(:args) { double('args') }
      let(:options) { { args: args } }
      it { expect(subject.args).to eq(args) }
    end
  end
  describe "last_time fact" do
    subject { job_throttle.fact(:last_time).from(job_throttle) }
    let(:last_time_key) { 'LastTime' }
    let(:options) { { last_time_key: last_time_key } }
    let(:cache) { double('cache') }
    before(:each) do
      allow(cache).to receive(:read).with(String).and_return(Time.now)
      Butterfli.cache = cache
    end
    after(:each) { Butterfli.cache = nil }
    it do
      expect(cache).to receive(:read).with(last_time_key)
      expect(subject).to be_a_kind_of(Time)
    end
  end
  describe "args matcher" do
    subject { job_throttle.applies_to?(job) }
    let(:job) { double('job') }
    let(:args) { { } }
    before(:each) { allow(job).to receive(:args).and_return(args) }
    context "when it contains no arguments" do
      let(:options) { { type: job.class } }
      it { expect(subject).to be true }
    end
    context "when it contains all matching arguments" do
      let(:args) { { obj_id: 1 } }
      let(:options) { { type: job.class, args: args } }
      it { expect(subject).to be true }
    end
    context "when it contains at least one non-matching argument" do
      let(:args) { { obj_id: 1, something: false } }
      let(:options) { { type: job.class, args: args.merge(something: true) } }
      it { expect(subject).to be false }
    end
  end
end 