require 'spec_helper'

describe SendCampaignJob do
  let(:campaign) { create :campaign     }
  let(:list)     { create :contact_list }
  
  describe 'class methods' do
    describe '#perform_later' do
      it 'enqueues a SendCampaignJob with Delayed::Job' do
        job = SendCampaignJob.new(campaign.id, list.id)
        SendCampaignJob.stub(:new).with(campaign.id, list.id).and_return(job)
        
        Delayed::Job.should_receive(:enqueue).with(job)
        
        SendCampaignJob.perform_later(campaign, list)
      end
    end
  end
  
  describe 'instance methods' do
    describe '#perform' do
      let!(:contact) { create :contact, list: list }
      
      it 'creates recipients from the contacts in the contact list' do
        job = SendCampaignJob.new(campaign.id, list.id)
        
        expect { job.perform }.to change { Recipient.count }.by +1
        
        recipient = Recipient.last
        expect(recipient.contact).to  eql contact
        expect(recipient.email).to    eql contact.email
        expect(recipient.campaign).to eql campaign
      end
      
      it 'only creates missing recipients from the contacts in the contact list' do
        recipient = create :recipient, campaign: campaign, contact: contact, email: contact.email
        job = SendCampaignJob.new(campaign.id, list.id)
        
        expect { job.perform }.to_not change { Recipient.count }
      end
      
      it 'delays the delivery of campaigns to the list recipients' do
        job = SendCampaignJob.new(campaign.id, list.id)
        
        recipient = create :recipient, campaign: campaign, contact: contact, email: contact.email
        DeliverCampaignJob.should_receive(:perform_later).with(campaign, recipient)
        
        job.perform
      end
    end
  end
end