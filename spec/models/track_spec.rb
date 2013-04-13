require 'spec_helper'

describe Track do
  subject(:track) { build :track }
  
  it { should be_valid }
end
