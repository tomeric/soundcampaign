require 'spec_helper'

describe User do
  subject(:user) { build :user }
  
  it { should be_valid }
end