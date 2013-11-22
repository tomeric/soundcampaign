require 'poster_generator'

class Release < ActiveRecord::Base
  include Archivable
  
  ### PAPERCLIP:
  
  has_attached_file :poster
  
  has_attached_file :cover,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  belongs_to :label
  
  has_one :campaign
  
  has_many :tracks,
    order: :position
  accepts_nested_attributes_for :tracks
  
  has_many :track_events,
    through: :tracks,
    source:  :events
  
  has_many :release_artists
  
  has_many :artists,
    through: :release_artists
  
  has_many :feedbacks
  
  ### VALIDATIONS:
  
  validates :title,
    presence: true
  
  ### CALLBACKS:
  
  before_save :generate_poster, if: :cover_changed?
  
  ### INSTANCE METHODS:
  
  def generate_poster(options = {})
    if cover?
      generator   = PosterGenerator.new(cover_io, options)
      self.poster = generator.create
    end
  end
  
  def cover_changed?
    cover.dirty?
  end
  
  def tracks=(new_tracks)
    result = super new_tracks
    reorder_tracks! Array.wrap(new_tracks).flatten.map(&:id)
    result
  end
  
  def track_ids=(new_track_ids)
    result = super new_track_ids
    reorder_tracks! Array.wrap(new_track_ids).flatten
    result
  end
  
  def reorder_tracks!(ordered_track_ids)
    ordered_track_ids.each.with_index do |track_id, index|
      Track.where(id: track_id).update_all position: index + 1
    end
  end
  
  private
  
  def cover_io
    file = cover.queued_for_write[:original]
    file || Paperclip.io_adapters.for(cover)
  end
  
end
