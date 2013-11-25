class SendCampaignJob < Struct.new(:campaign_id, :contact_list_id)
  
  def self.perform_later(campaign, contact_list)
    Delayed::Job.enqueue new(campaign.id, contact_list.id)
  end
  
  def perform
    campaign = Campaign.find campaign_id
    list     = ContactList.find contact_list_id
    
    list.contacts.each do |contact|
      recipient = campaign.recipients.where(email: contact.email)
                                     .first_or_initialize
      recipient.contact = contact
      recipient.save
      
      DeliverCampaignJob.perform_later campaign, recipient
    end
  end
  
end
