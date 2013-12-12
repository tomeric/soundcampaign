require 'spec_helper'

describe CampaignMailer do
  let(:campaign)  { create :campaign                      }
  let(:recipient) { create :recipient, campaign: campaign }
  
  describe 'preview_campaign' do
    subject(:mail) { CampaignMailer.preview_campaign(campaign, recipient) }
    
    it 'prepends the subject of the campaign with "[Preview]"' do
      expect(mail).to have_subject "[Preview] #{campaign.email_subject}"
    end
    
    it 'mails to the recipient' do
      expect(mail).to deliver_to recipient.email
    end
    
    it 'mails from the configured campaign email' do
      expect(mail).to deliver_from Settings.campaign_email
    end
  end
  
  describe 'normal_campaign' do
    subject(:mail) { CampaignMailer.normal_campaign(campaign, recipient) }
    
    it 'uses the subject of the campaign' do
      expect(mail).to have_subject campaign.email_subject
    end
    
    it 'supports a custom subject' do
      mail = CampaignMailer.normal_campaign(campaign, recipient, 'Custom Subject')
      expect(mail).to have_subject 'Custom Subject'
    end
    
    it 'mails to the recipient' do
      expect(mail).to deliver_to recipient.email
    end
    
    it 'mails from the configured campaign email' do
      expect(mail).to deliver_from Settings.campaign_email
    end
  end
end
