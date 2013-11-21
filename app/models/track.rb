require 'taglib'
require 'paperclip/processors/audio_processor'

class Track < ActiveRecord::Base
  include Archivable
  
  ### PAPERCLIP:
  
  has_attached_file :attachment,
    processors: %i[audio],
    styles: {
      streaming: { params: '--abr 96', format: 'mp3' },
      download:  { params: '-V 1',     format: 'mp3' }
    }
  
  process_in_background :attachment
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  belongs_to :release
  
  has_many :events,
    class_name: 'TrackEvent'
  
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
  
  before_validation :set_track_attributes,
    on: :create
  
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
    set_track_attributes_from_attachment_tags if attachment?
    
    self.artist ||= 'Unknown Artist'
    self.title  ||= 'Unknown Title'
  end
  
  def set_attachment_tags_from_track_attributes
    pathname = Pathname.new(attachment_io.path)
    
    TagLib::FileRef.open(pathname.to_s) do |file|
      return if file.null?
      
      if tag = file.tag
        tag.artist = artist
        tag.title  = title
        tag.album  = release.try(:title)
        tag.track  = (position.presence || 0) + 1
      end
      
      file.save
    end
    
    self.attachment = pathname
  end
  
  def set_track_attributes_from_attachment_tags
    TagLib::FileRef.open(attachment_io.path) do |file|
      return if file.null?
      
      if tag = file.tag
        self.artist ||= tag.artist.presence
        self.title  ||= tag.title.presence
      end
      
      if properties = file.audio_properties
        self.length      = properties.length
        self.bitrate     = properties.bitrate
        self.sample_rate = properties.sample_rate
        self.channels    = properties.channels
      end
    end
  end
  
  private
  
  def attachment_io
    file = attachment.queued_for_write[:original]
    file || Paperclip.io_adapters.for(attachment)
  end
  
end
