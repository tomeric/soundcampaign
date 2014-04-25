require 'spec_helper'

describe CampaignOpenEvent do
  subject(:event) { build :campaign_open_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on create' do
      let(:email_log) { event.parent }
      
      it "sets the event's created_at to the email log's opened_at" do
        Timecop.freeze do
          email_log.opened_at = 3.days.ago
          expect {
            event.save
          }.to change {
            event.created_at
          }.to 3.days.ago
        end
      end
      
      it "sets the event's release to the email log's release" do
        expect {
          event.save
        }.to change {
          event.release
        }.to email_log.campaign.release
      end
      
      it "sets the event's recipient to the email log's recipient" do
        expect {
          event.save
        }.to change {
          event.recipient
        }.to email_log.recipient
      end
    end
  end
  
  context 'class methods' do
    describe '.for' do
      it 'creates a single CampaignOpenEvent for a opened EmailLog' do
        email_log = create :opened_email_log
        CampaignOpenEvent.delete_all
        
        expect {
          CampaignOpenEvent.for(email_log)
        }.to change {
          CampaignOpenEvent.count
        }.by +1
        
        expect {
          CampaignOpenEvent.for(email_log)
        }.to_not change {
          CampaignOpenEvent.count
        }
      end
      
      it "doesn't create a CampaignOpenEvent for a unopened EmailLog" do
        email_log = create :unopened_email_log
        CampaignOpenEvent.delete_all
        
        expect {
          CampaignOpenEvent.for(email_log)
        }.to_not change {
          CampaignOpenEvent.count
        }
      end
    end
  end
end
