class MetricsController < ApplicationController
  
  before_action :require_user
  
  before_action :set_release_and_campaign
  
  before_action :require_release_owner
  
  def show
    # Counters on top of page:
    @recipient_count   = @campaign.recipients.count
    @feedback_count    = @release.feedbacks.count
    @open_count        = @campaign.email_logs.opened.count
    @open_today_count  = @campaign.email_logs.opened(Date.today).count
    @plays_count       = @campaign.release.track_events.played.count
    @plays_today_count = @campaign.release.track_events.played(Date.today).count
    
    # Graphs:
    @opens_per_day = @campaign.email_logs.number_of   :opens, per: 1.day
    @plays_per_day = @campaign.track_events.number_of :plays, per: 1.day
    
    # Lists:
    @feedbacks = @release.feedbacks
                         .order(created_at: :desc)
    @tracks    = @release.tracks
                         .includes(:ratings)
    @events    = @release.events
                         .without_previous_siblings
                         .includes(recipient: :contact)
                         .order(created_at: :desc)
    
    # Grouped:
    @events_by_date = @events.group_by { |e| e.created_at.to_date }
  end
  
  private
  
  def set_release_and_campaign
    @release  = Release.find_by id: params[:release_id]
    @campaign = @release.campaign
  end
  
end
