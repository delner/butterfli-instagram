require 'spec_helper'

describe Butterfli::Instagram::Data::Cache::Query do
  let(:query) { Butterfli::Instagram::Data::Cache::Query.new }
  describe "#subscription" do
    subject { query.subscription(subtype, id) }
    context "when given a subtype and id" do
      let(:subtype) { :geography }
      let(:id) { 123 }
      it { expect(subject.obj_type).to eq('Subscription') }
      it { expect(subject.obj_subtype).to eq('Geography') }
      it { expect(subject.obj_id).to eq(id) }
    end
  end
  describe "#field" do
    subject { query.field(name) }
    context "when given a name" do
      let(:name) { :min_tag_id }
      it { expect(subject.field_name).to eq('MinTagId') }
    end
  end
  context "when chaining dimensions" do
    subject { query.subscription(subtype, id).field(name) }
    let(:subtype) { :geography }
    let(:id) { 123 }
    let(:name) { :min_tag_id }
    it { expect(subject.obj_type).to eq('Subscription') }
    it { expect(subject.obj_subtype).to eq('Geography') }
    it { expect(subject.obj_id).to eq(id) }
    it { expect(subject.field_name).to eq('MinTagId') }
  end

  describe "#key" do
    subject { query.key }
    context "when no dimensions have been set" do
      it { expect(subject).to eq('Instagram') }
    end
    context "after multiple dimensions have been set" do
      let(:subtype) { :geography }
      let(:id) { 123 }
      let(:name) { :min_tag_id }
      before(:each) { query.subscription(subtype, id).field(name) }
      it { expect(subject).to eq("Instagram:Subscription:Geography:#{id}:MinTagId") }
    end
  end
  describe "#read" do
    subject { query.read }
    let(:cache) { double('cache') }
    before(:each) do
      allow(cache).to receive(:read).with(String).and_return(Time.now)
      Butterfli.cache = cache
    end
    after(:each) { Butterfli.cache = nil }
    it do
      expect(cache).to receive(:read).with(query.key)
      expect(subject).to be_a_kind_of(Time)
    end
  end
  describe "#write" do
    subject { query.write(value) }
    context "when given a value" do
      let(:value) { Time.now }
      let(:cache) { double('cache') }
      before(:each) do
        allow(cache).to receive(:write).with(String, Object)
        Butterfli.cache = cache
      end
      after(:each) { Butterfli.cache = nil }
      it { expect(cache).to receive(:write).with(query.key, value); subject }
    end
  end
end