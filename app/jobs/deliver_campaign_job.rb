class DeliverCampaignJob < Struct.new(:campaign_id, :recipient_id, :preview)
  
  ### CLASS METHODS:
  
  def self.perform_later(campaign, recipient, preview = false)
    Delayed::Job.enqueue new(campaign.id, recipient.id, preview)
  end
  
  ### INSTANCE METHODS:
  
  def perform
    campaign  = Campaign.find(campaign_id)
    recipient = Recipient.find(recipient_id)
    
    mail = if preview
             CampaignMailer.preview_campaign(campaign, recipient)
           else
             CampaignMailer.normal_campaign(campaign, recipient)
           end
    
    mail.deliver
  end
  
end
