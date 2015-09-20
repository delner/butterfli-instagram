require 'spec_helper'

describe Butterfli::Instagram::Data::Cache do
  describe "#for" do
    subject { Butterfli::Instagram::Data::Cache.for }
    it { expect(subject).to be_a_kind_of(Butterfli::Instagram::Data::Cache::Query) }
  end
end