class Artist < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  has_one :cover,
    as: :coverable
  
  belongs_to :organization
  
  has_many :release_artists
  
  has_many :releases,
    through: :release_artists
  
end
