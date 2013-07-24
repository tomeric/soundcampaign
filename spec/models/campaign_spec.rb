require 'spec_helper'

describe Campaign do
  subject(:campaign) { build :campaign }
  
  it { should be_valid }
end
