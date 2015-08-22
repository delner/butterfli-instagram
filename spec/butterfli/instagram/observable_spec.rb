require 'spec_helper'

describe Butterfli::Instagram do
  subject { Butterfli::Instagram }
  it { expect(subject).to respond_to(:subscribe) }
  it { expect(subject).to respond_to(:syndicate) }
end