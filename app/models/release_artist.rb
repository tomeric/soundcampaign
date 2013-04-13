class ReleaseArtist < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  belongs_to :artist
  
end
