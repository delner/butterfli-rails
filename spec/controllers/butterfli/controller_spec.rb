require 'spec_helper'

describe Butterfli::Controller do
  subject { Butterfli::Controller.new }

  it { expect(subject).to_not be_nil }
end