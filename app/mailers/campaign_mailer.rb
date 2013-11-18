class CampaignMailer < ActionMailer::Base
  helper MailHelper
  
  default from: Settings.campaign_email
  
  def preview_campaign(campaign, recipient)
    normal_campaign(campaign, recipient, "[Preview] #{campaign.email_subject}")
  end
  
  def normal_campaign(campaign, recipient, subject = nil)
    @campaign   = campaign
    @recipient  = recipient
    @secret     = @recipient.secret
    @release    = @campaign.release
    @label      = @release.label
    @tracks     = @release.tracks
    @message_id = "campaign:#{@campaign.id}+#{SecureRandom.uuid}"
    
    mail(to:            @recipient.email,
         subject:       subject || @campaign.email_subject,
         reply_to:      @campaign.email_from,
         template_name: 'campaign',
         message_id:    @message_id)
    
    headers['X-MC-Metadata'] = {
      message_id:  @message_id,
      campaign_id: @campaign.id
    }.to_json
  end
  
end
