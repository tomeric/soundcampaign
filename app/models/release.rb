require 'poster_generator'

class Release < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  has_one :cover,
    as: :coverable
  
  belongs_to :organization
  
  belongs_to :label
  
  has_one :campaign
  
  has_many :tracks,
    -> { order :position },
    dependent: :destroy
  accepts_nested_attributes_for :tracks
  
  has_many :events,
    class_name: ReleaseEvent
  
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
  
  validates :label,
    presence: true
  
  ### SCOPES:
  
  scope :pending, -> {
    joins('LEFT JOIN campaigns ON campaigns.release_id = releases.id')
    .where('campaigns.sent_at IS NULL')
  }
  
  scope :finished, -> {
    joins(:campaign).where('campaigns.sent_at IS NOT NULL')
  }
  
  ### INSTANCE METHODS:
  
  def cover_id
    cover.try(:id)
  end
  
  def cover_id=(new_cover_id)
    self.cover = Cover.find_by id: new_cover_id
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
  
end
