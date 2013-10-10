class CampaignMailer < ActionMailer::Base
  helper MailHelper
  
  default from: 'info@soundcampaign.com'
  
  def preview_campaign(campaign, recipients = [])
    normal_campaign(campaign, recipients, "[Preview] #{campaign.email_subject}")
  end
  
  def normal_campaign(campaign, recipients = [], subject = nil)
    @campaign   = campaign
    @release    = @campaign.release
    @label      = @release.label
    @tracks     = @release.tracks
    @message_id = "campaign:#{@campaign.id}+#{SecureRandom.uuid}"
    
    mail(to:            recipients,
         subject:       subject || campaign.email_subject,
         reply_to:      campaign.email_from,
         template_name: 'campaign',
         message_id:    @message_id)
    
    headers['X-MC-Metadata'] = {
      message_id:  @message_id,
      campaign_id: @campaign.id
    }.to_json
  end
  
end
