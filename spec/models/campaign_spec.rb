require 'spec_helper'

describe Campaign do
  subject(:campaign) { build :campaign }
  
  it { should be_valid }
  
  describe 'instance methods' do
    describe '#sent?' do
      it 'returns true if sent_at is set' do
        campaign.sent_at = Time.now
        expect(campaign.sent?).to be_true
      end
      
      it 'returns false if sent_at is nil' do
        campaign.sent_at = nil
        expect(campaign.sent?).to be_false
      end
    end
  end
end
