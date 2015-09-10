require 'spec_helper'

describe Butterfli::Rails::Controller do
  subject { Butterfli::Rails::Controller.new }

  it { expect(subject).to_not be_nil }
end