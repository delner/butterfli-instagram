require 'spec_helper'

RSpec.shared_examples_for "a request for stories (tag)" do
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

describe Butterfli::Instagram::Jobs::TagRecentMedia do
  let(:options) { { } }
  let(:job) { Butterfli::Instagram::Jobs::TagRecentMedia.new(options) }

  let(:pagination_extension) do
    stub_const 'PaginationExtension', Module.new
    PaginationExtension.class_eval { attr_reader :pagination }
    PaginationExtension
  end
  let(:min_tag_id) { "1077811283151212589" }
  let(:next_max_tag_id) { "1077811082941429864" }
  let(:pagination) do
    Hashie::Mash.new({  next_max_tag_id: next_max_tag_id,
                        next_max_id: next_max_tag_id,
                        next_min_id: min_tag_id,
                        min_tag_id: min_tag_id })
  end

  let(:cache) { double('cache') }
  before(:each) do
    allow(cache).to receive(:write)
    Butterfli.cache = cache
  end
  after(:each) { Butterfli.cache = nil }

  context "when comparing" do
    context "to a job with identical options" do
      let(:obj_id) { "1" }
      let(:min_tag_id) { "2" }
      let(:options) { { obj_id: obj_id, min_tag_id: min_tag_id } }
      let(:other_job) { Butterfli::Instagram::Jobs::TagRecentMedia.new(options) }

      it do
        expect(job).to_not eq(other_job)
        expect(job.eql?(other_job)).to be true
      end
      context "except obj_id" do
        let(:other_job) do
          Butterfli::Instagram::Jobs::TagRecentMedia.new(options.merge(obj_id: obj_id + "1"))
        end
        it do
          expect(job).to_not eq(other_job)
          expect(job.eql?(other_job)).to be false
        end
      end
      context "except min_tag_id" do
        let(:other_job) do
          Butterfli::Instagram::Jobs::TagRecentMedia.new(options.merge(min_tag_id: min_tag_id + "1"))
        end
        it do
          expect(job).to_not eq(other_job)
          expect(job.eql?(other_job)).to be true # Equivalent because we don't care if min_tag_id is the same
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
        allow(job.client).to receive(:tag_recent_media).with(obj_id, Hash) do
          media_objects.extend(pagination_extension)
          media_objects.instance_variable_set("@pagination", pagination)
          media_objects
        end
      end
      it_behaves_like "a request for stories (tag)"
      context "and a min_id" do
        let(:min_id) { "2" }
        let(:options) { { obj_id: obj_id, min_id: min_id } }
        it_behaves_like "a request for stories (tag)"
      end
    end
  end
  describe "#work" do
    subject { job.work }
    let(:min_tag_id) { 123 }
    let(:max_tag_id) { 321 }
    before(:each) do
      allow(job).to receive(:get_stories) do
        job.min_tag_id = 123
        job.max_tag_id = 321
        job.max_obj_id = stories.last.source.id if !stories.empty?
        stories
      end
    end
    context "when it doesn't retrieve a story" do
      let(:stories) { [] }
      it do
        expect(cache).to_not receive(:read)
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:last_time_ran).key, Time)
        subject
      end
    end
    context "when it retrieves a story" do
      let(:story) { s = Butterfli::Data::Story.new; s.source.id = 1; s }
      let(:stories) { [story] }
      it do
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:last_time_ran).key, Time)
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:min_tag_id).key, min_tag_id)
        expect(cache).to receive(:write).with(Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:max_tag_id).key, max_tag_id)
        subject
      end
    end
  end
end