require 'spec_helper'

describe Subscriber do
  subject(:subscriber) { build :subscriber }
  
  it { should be_valid }
  
  context 'validations' do
    it { should allow_value('info@soundcampaign.com').for(:email) }
    it { should_not allow_value('not a valid e-mail').for(:email) }
  end
end