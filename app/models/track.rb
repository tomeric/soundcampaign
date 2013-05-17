class Track < ActiveRecord::Base
  include Archivable
  
  ### PAPERCLIP:
  
  has_attached_file :attachment
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
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
  
  def as_json
    {
      id: id,
      release_id: release.try(:id),
      title: title,
      artist: artist,
      attachment: (attachment.url if attachment?)
    }
  end
  
  def set_track_attributes
    set_track_attributes_from_attachment if attachment?
    
    self.artist ||= 'Unknown Artist'
    self.title  ||= 'Unknown Title'
  end
  
  private
  
  def set_track_attributes_from_attachment
    begin
      Mp3Info.open(attachment_io.path) do |info|
        self.artist ||= info.tag.artist.presence
        self.title  ||= info.tag.title.presence
      end
    rescue => e
      puts e.inspect
    end
  end
  
  def attachment_io
    file = attachment.queued_for_write[:original]
    file || Paperclip.io_adapters.for(attachment)
  end
  
end
