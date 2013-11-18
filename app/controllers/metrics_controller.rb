class MetricsController < ApplicationController
  
  before_action :require_user
  
  before_action :set_release_and_campaign
  
  before_action :require_release_owner
  
  def show
    @recipient_count  = @campaign.email_logs.count
    @feedback_count   = @release.feedbacks.count
    @open_count       = @campaign.email_logs.opened.count
    @open_today_count = @campaign.email_logs.opened(Date.today).count
    @opens_per_day    = @campaign.email_logs.number_of :opens,  per: 1.day
    @clicks_per_day   = @campaign.email_logs.number_of :clicks, per: 1.day
    
    @feedbacks = @release.feedbacks
  end
  
  private
  
  def set_release_and_campaign
    @release  = Release.find_by id: params[:release_id]
    @campaign = @release.campaign
  end
  
end
