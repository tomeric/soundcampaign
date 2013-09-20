class CampaignMailer < ActionMailer::Base
  helper MailHelper
  
  default from: 'info@soundcampaign.com'
  
  def preview_campaign(campaign, recipients)
    @campaign = campaign
    @release  = @campaign.release
    @label    = @release.label
    @tracks   = @release.tracks
    
    mail(to:            recipients,
         subject:       "[Preview] #{campaign.email_subject}",
         reply_to:      campaign.email_from,
         template_name: 'campaign')
  end
  
end
