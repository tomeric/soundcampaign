class Role < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :user
  
end
