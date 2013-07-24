class Campaign < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
end
