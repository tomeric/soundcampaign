class TrackEventsController < ApplicationController
  def index
    head :ok
  end
  
  def create
    @track = Track.find_by id: params[:track]
    return head :not_found unless @track.present?
    
    @release  = @track.release
    @campaign = @release.try(:campaign)
    return head :not_found unless @campaign.present?
    
    @recipient = @campaign.recipients.find_by secret: params[:secret]
    
    if @recipient.present?
      @track.events.create(
        action:       params[:event],
        recipient:    @recipient,
        payload_json: params.except(:controller, :action, :track, :event, :secret).to_json
      )
      
      head :created
    else
      head :ok
    end
  end
end
