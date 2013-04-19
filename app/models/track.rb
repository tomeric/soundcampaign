class Track < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :attachment
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  ### VALIDATIONS:
  
  validates_attachment :attachment,
    presence: true,
    content_type: {
      content_type: %r{audio/.*}
    }
  
  validates :title,
    presence: true
  
  validates :artist,
    presence: true
  
  ### CALLBACKS:
  
  before_validation :set_track_attributes, on: :create
  
  ### INSTANCE METHODS:
  
  def set_track_attributes
    self.artist ||= 'Unknown Artist'
    self.title  ||= 'Unknown Title'
  end
  
end
