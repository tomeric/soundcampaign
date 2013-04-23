require 'spec_helper'

describe Contact do
  subject(:contact) { build :contact }
  
  it { should be_valid }
  
  context 'validations' do
    it { should allow_value('info@soundcampaign.com').for(:email) }
    it { should_not allow_value('not a valid e-mail').for(:email) }
  end
end
