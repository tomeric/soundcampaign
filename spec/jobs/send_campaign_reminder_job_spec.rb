require 'spec_helper'

describe SendCampaignReminderJob do
  let(:campaign) { create :campaign     }
  let(:list)     { create :contact_list }
  
  describe 'class methods' do
    describe '#perform_later' do
      it 'enqueues a SendCampaignReminderJob with Delayed::Job' do
        job = SendCampaignReminderJob.new(campaign.id, list.id)
        SendCampaignReminderJob.stub(:new).with(campaign.id, list.id).and_return(job)
        
        Delayed::Job.should_receive(:enqueue).with(job)
        
        SendCampaignReminderJob.perform_later(campaign, list)
      end
    end
  end
  
  describe 'instance methods' do
    describe '#perform' do
      let!(:contact) { create :contact, list: list }
      
      it 'creates recipients from the contacts in the contact list' do
        job = SendCampaignReminderJob.new(campaign.id, list.id)
        
        expect { job.perform }.to change { Recipient.count }.by +1
        
        recipient = Recipient.last
        expect(recipient.contact).to  eql contact
        expect(recipient.email).to    eql contact.email
        expect(recipient.campaign).to eql campaign
      end
      
      it 'only creates missing recipients from the contacts in the contact list' do
        recipient = create :recipient, campaign: campaign, contact: contact, email: contact.email
        job = SendCampaignReminderJob.new(campaign.id, list.id)
        
        expect { job.perform }.to_not change { Recipient.count }
      end
      
      it 'delays the delivery of campaigns to the list recipients' do
        job = SendCampaignReminderJob.new(campaign.id, list.id)
        
        recipient = create :recipient, campaign: campaign, contact: contact, email: contact.email
        
        DeliverCampaignJob.should_receive(:perform_later).with(campaign, recipient)
        job.perform
      end
      
      it 'does not send campaigns to recipients that already clicked a link in the campaign' do
        job = SendCampaignReminderJob.new(campaign.id, list.id)
        
        recipient = create :recipient, campaign: campaign, contact: contact, email: contact.email
        email_log = create :email_log, recipient: recipient, clicked_at: Time.now
        
        DeliverCampaignJob.should_not_receive(:perform_later)
        job.perform
      end
    end
  end
end