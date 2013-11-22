require 'spec_helper'

describe DeliverCampaignJob do
  let(:campaign)  { create :campaign  }
  let(:recipient) { create :recipient }
  
  describe 'class methods' do
    describe '#perform_later' do
      it 'enqueues a DeliverCampaignJob with Delayed::Job' do
        job = DeliverCampaignJob.new(campaign.id, recipient.id)
        DeliverCampaignJob.stub(:new).with(campaign.id, recipient.id, false).and_return(job)
        
        Delayed::Job.should_receive(:enqueue).with(job)
        
        DeliverCampaignJob.perform_later(campaign, recipient)
      end
    end
  end
  
  describe 'instance methods' do
    describe '#perform' do
      it 'delivers a normal campaign' do
        job = DeliverCampaignJob.new(campaign.id, recipient.id)
        
        mail = double
        CampaignMailer.should_receive(:normal_campaign)
                      .with(campaign, recipient)
                      .and_return(mail)
        mail.should_receive(:deliver)
        
        job.perform
      end
      
      it 'delivers a preview campaign if specified' do
        job = DeliverCampaignJob.new(campaign.id, recipient.id, true)
        
        mail = double
        CampaignMailer.should_receive(:preview_campaign)
                      .with(campaign, recipient)
                      .and_return(mail)
        mail.should_receive(:deliver)
        
        job.perform
      end
    end
  end
end