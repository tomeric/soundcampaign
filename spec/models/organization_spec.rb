require 'spec_helper'

describe Organization do
  subject(:organization) { build :organization }
  
  it { should be_valid }
  
end
