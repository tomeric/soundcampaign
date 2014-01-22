class TrackPlayEvent < ReleaseEvent
  
  ### ASSOCIATIONS:
  
  belongs_to :parent,
    class_name: TrackEvent
  
  ### CALLBACKS:
  
  before_create :set_attributes_from_parent

  ### CLASS METHODS:
  
  def self.for(track_event)
    return unless track_event.action == 'play-track'
    
    where(parent: track_event).first_or_create
  end
  
  ### INSTANCE METHODS:
  
  private
  
  def set_attributes_from_parent
    self.created_at = parent.created_at
    self.recipient  = parent.recipient
    self.release    = parent.track.try(:release)
  end
  
end
