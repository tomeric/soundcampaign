require 'spec_helper'

describe Artist do
  subject(:artist) { build :artist }
  
  it { should be_valid }
end
