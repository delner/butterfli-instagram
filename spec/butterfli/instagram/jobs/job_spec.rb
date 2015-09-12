require 'spec_helper'

describe Butterfli::Instagram::Job do
  let(:job_class) do
    stub_const 'TestJob', Class.new
    TestJob.class_eval { include Butterfli::Instagram::Job }
    TestJob
  end
  let(:job) { job_class.new }
  before(:each) { configure_for_instagram }

  describe "#client" do
    subject { job.client }
    it { expect(job).to respond_to(:client) }
    it { expect(subject).to be_a_kind_of(Instagram::Client) }
  end
  describe "#convert_media_objects_to_stories" do
    subject { job.convert_media_objects_to_stories(media_objects) }
    it { expect(job).to respond_to(:convert_media_objects_to_stories) }
    context "when given an empty collection" do
      let(:media_objects) { read_media_objects_fixture('media_objects/empty') }
      it { expect(subject).to be_empty }
    end
    context "when given a collection of media objects" do
      let(:media_objects) { read_media_objects_fixture('media_objects/collection') }
      it { expect(subject).to have_exactly(media_objects.length).items }
    end
  end
end