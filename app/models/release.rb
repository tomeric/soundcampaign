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
  
  has_many :tracks
  accepts_nested_attributes_for :tracks
  
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
  
  private
  
  def cover_io
    file = cover.queued_for_write[:original]
    file || Paperclip.io_adapters.for(cover)
  end
  
end
