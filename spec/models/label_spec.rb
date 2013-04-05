require 'spec_helper'

describe Label do
  subject(:label) { build :label }
  
  it { should be_valid }
end
