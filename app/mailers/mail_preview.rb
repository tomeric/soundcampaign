class MailPreview < MailView
  def campaign
    if campaign = Campaign.offset(rand(Campaign.count)).first
      recipient = campaign.recipients.first || campaign.recipients.new(email: 'john.doe@example.com')
      CampaignMailer.normal_campaign(campaign, recipient)
    end
  end
end
