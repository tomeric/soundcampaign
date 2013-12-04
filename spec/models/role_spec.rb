require 'spec_helper'

describe Role do
  subject(:role) { build :role }
  
  it { should be_valid }
end
