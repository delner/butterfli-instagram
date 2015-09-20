require 'spec_helper'

describe Butterfli::Instagram::Regulation do
  describe "#policies" do
    subject { Butterfli::Instagram::Regulation.policies }
    after(:each) { Butterfli::Instagram::Regulation.policies = nil }

    context "when no policies have been configured" do
      before(:each) { Butterfli::Instagram::Regulation.policies = nil }
      it { expect(subject).to be_empty }
    end
    context "when a policy has been configured" do
      let(:policy_name) { :jobs }
      before(:each) do
        configure_for_instagram do |provider|
          provider.policy policy_name do |jobs|
            jobs.throttle :geography do |t|
              t.matching obj_id: 1
              t.limit 1
              t.per_seconds 1
            end
          end
        end
      end
      it { expect(subject).to have_exactly(1).items }
      it { expect(subject).to include(policy_name) }
      it { expect(subject[policy_name]).to be_a_kind_of(Butterfli::Instagram::Regulation::JobsPolicy) }
      it { expect(subject[policy_name].rules).to have_exactly(1).items }
      it { expect(subject[policy_name].rules.first).to be_a_kind_of(Butterfli::Instagram::Regulation::JobThrottle) }
    end
  end
end