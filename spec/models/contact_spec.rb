require 'spec_helper'
require_relative './concerns/archivable'

describe Contact do
  subject(:contact) { build :contact }
  
  it { should be_valid }
  
  it_behaves_like Archivable
  
  context 'validations' do
    it { should allow_value('info@soundcampaign.com').for(:email) }
    it { should_not allow_value('not a valid e-mail').for(:email) }
  end
end
