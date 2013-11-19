class TrackEvent < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :track
  
  belongs_to :recipient
  
end
