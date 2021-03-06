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
    
    describe '#send_to' do
      let(:campaign) { create :campaign     }
      let(:list)     { create :contact_list }
      
      context 'already sent campaign' do
        let(:campaign) { create :campaign, sent_at: Time.now }
        
        it 'sends the campaign reminder to every list given' do
          first_list  = list
          second_list = create :contact_list
          
          SendCampaignReminderJob.should_receive(:perform_later).with(campaign, first_list)
          SendCampaignReminderJob.should_receive(:perform_later).with(campaign, second_list)
          
          campaign.send_to first_list, second_list
        end
        
        it "doesn't update sent_at" do
          Timecop.travel 1.day.from_now do
            expect {
              campaign.send_to list
            }.to_not change {
              campaign.sent_at
            }
          end
        end
        
        it 'returns false if no lists are given' do
          expect(campaign.send_to([])).to be false
        end
      end
      
      context 'unsent campaign' do
        it 'sends the campaign to every list given' do
          first_list  = list
          second_list = create :contact_list
          
          SendCampaignJob.should_receive(:perform_later).with(campaign, first_list)
          SendCampaignJob.should_receive(:perform_later).with(campaign, second_list)
          
          campaign.send_to first_list, second_list
        end
        
        it 'updates sent_at to the current time' do
          Timecop.freeze Time.now do
            campaign.send_to list
            expect(campaign.sent_at).to eql Time.now
          end
        end
        
        it "doesn't update sent_at if no lists are given" do
          campaign.send_to []
          expect(campaign.sent_at).to be_nil
        end
      end
    end
  end
end
