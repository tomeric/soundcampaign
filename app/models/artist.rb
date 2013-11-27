class Artist < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  has_one :cover,
    as: :coverable
  
  belongs_to :organization
  
  has_many :release_artists
  
  has_many :releases,
    through: :release_artists
  
  ### INSTANCE METHODS:
  
  def cover_id
    cover.try(:id)
  end
  
  def cover_id=(new_cover_id)
    self.cover = Cover.find_by id: new_cover_id
  end
  
end
