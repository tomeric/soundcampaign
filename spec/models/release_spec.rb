require 'spec_helper'

describe Release do
  subject(:release) { build :release }
  
  it { should be_valid }
end
