class Artist < ActiveRecord::Base
  include Archivable
  
  ### PAPERCLIP:
  
  has_attached_file :cover,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :release_artists
  
  has_many :releases,
    through: :release_artists
  
end
