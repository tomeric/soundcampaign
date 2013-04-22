require 'spec_helper'

describe Contact do
  subject(:contact) { build :contact }
  
  it { should be_valid }
  
end
