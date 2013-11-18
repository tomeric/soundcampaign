class TrackEvent < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :track
  
  belongs_to :user
  
  belongs_to :subscriber
  
end
