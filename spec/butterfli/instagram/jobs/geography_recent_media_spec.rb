require 'spec_helper'

RSpec.shared_examples_for "a request for stories (geography)" do
  context "that retrieves no media objects" do
    let(:media_objects) do
      read_media_objects_fixture('media_objects/empty')
    end
    it do
      expect(subject).to be_a_kind_of(Array)
      expect(subject).to be_empty
      expect(job.max_obj_id).to be_nil
    end
  end
  context "that retrieves multiple media objects" do
    let(:media_objects) do
      read_media_objects_fixture('media_objects/collection')
    end
    it do
      expect(subject).to be_a_kind_of(Array)
      expect(subject).to have_exactly(media_objects.length).items
      expect(job.max_obj_id).to eq(media_objects.first['id'])
    end
  end
end

describe Butterfli::Instagram::Jobs::GeographyRecentMedia do
  let(:options) { { } }
  let(:job) { Butterfli::Instagram::Jobs::GeographyRecentMedia.new(options) }

  let(:cache) { double('cache') }
  before(:each) do
    allow(cache).to receive(:write)
    Butterfli.cache = cache
  end
  after(:each) { Butterfli.cache = nil }

  context "when comparing" do
    context "to a job with identical options" do
      let(:obj_id) { "1" }
      let(:min_id) { "2" }
      let(:options) { { obj_id: obj_id, min_id: min_id } }
      let(:other_job) { Butterfli::Instagram::Jobs::GeographyRecentMedia.new(options) }

      it do
        expect(job).to_not eq(other_job)
        expect(job.eql?(other_job)).to be true
      end
      context "except obj_id" do
        let(:other_job) do
          Butterfli::Instagram::Jobs::GeographyRecentMedia.new(options.merge(obj_id: obj_id + "1"))
        end
        it do
          expect(job).to_not eq(other_job)
          expect(job.eql?(other_job)).to be false
        end
      end
      context "except min_id" do
        let(:other_job) do
          Butterfli::Instagram::Jobs::GeographyRecentMedia.new(options.merge(min_id: min_id + "1"))
        end
        it do
          expect(job).to_not eq(other_job)
          expect(job.eql?(other_job)).to be true # Equivalent because we don't care if min_id is the same
        end
      end
    end
  end
  describe "#get_stories" do
    subject { job.get_stories }
    context "with no obj_id argument" do
      it { expect { subject }.to raise_error(ArgumentError) }
    end
    context "with an obj_id argument" do
      let(:obj_id) { "1" }
      let(:options) { { obj_id: obj_id } }
      before(:each) do
        allow(job.client).to receive(:geography_recent_media).with(obj_id, Hash) { media_objects }
      end
      it_behaves_like "a request for stories (geography)"
      context "and a min_id" do
        let(:min_id) { "2" }
        let(:options) { { obj_id: obj_id, min_id: min_id } }
        it_behaves_like "a request for stories (geography)"
      end
    end
  end
  describe "#work" do
    subject { job.work }
    before(:each) do
      allow(job).to receive(:get_stories) do
        job.max_obj_id = stories.last.source.id if !stories.empty?
        stories
      end
    end
    context "when it doesn't retrieve a story" do
      let(:stories) { [] }
      it do
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:geography, job.args[:obj_id]).field(:last_time_ran).key, Time)
        subject
      end
    end
    context "when it retrieves a story" do
      let(:story) { s = Butterfli::Data::Story.new; s.source.id = 1; s }
      let(:stories) { [story] }
      it do
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:geography, job.args[:obj_id]).field(:last_time_ran).key, Time)
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:geography, job.args[:obj_id]).field(:max_obj_id).key, story.source.id)
        subject
      end
    end
  end
end