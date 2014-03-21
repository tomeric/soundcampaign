class TrackPlayEvent < ReleaseEvent
  
  ### ASSOCIATIONS:
  
  belongs_to :parent,
    class_name: TrackEvent
  
  ### CALLBACKS:
  
  before_create :set_attributes_from_parent

  ### CLASS METHODS:
  
  def self.for(track_event_or_id)
    track_event = track_event_or_id.is_a?(TrackEvent)  ?
                    track_event_or_id                  :
                    TrackEvent.find(track_event_or_id)
    
    if track_event.try(:action) == 'play-track'
      where(parent: track_event).first_or_create
    end
  end
  
  ### INSTANCE METHODS:
  
  private
  
  def set_attributes_from_parent
    self.created_at = parent.created_at
    self.recipient  = parent.recipient
    self.release    = parent.track.try(:release)
  end
  
end
