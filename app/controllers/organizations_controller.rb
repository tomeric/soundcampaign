class OrganizationsController < ApplicationController
  
  before_filter :require_admin
  
  def index
    @organizations = Organization.order(created_at: :desc).all
    
    # Counters on top of page:
    @recipient_count   = Recipient.count
    @feedback_count    = Feedback.count
    @open_count        = EmailLog.opened.count
    @open_today_count  = EmailLog.opened(Date.today).count
    @plays_count       = TrackEvent.played.count
    @plays_today_count = TrackEvent.played(Date.today).count
    
    # Graphs:
    @opens_per_day = EmailLog.number_of   :opens, per: 1.day
    @plays_per_day = TrackEvent.number_of :plays, per: 1.day
  end
  
end
