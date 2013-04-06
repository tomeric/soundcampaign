class Subscriber < ActiveRecord::Base
  
  ### VALIDATIONS:
  
  validates :email,
    presence:   true,
    email:      true,
    uniqueness: true
  
end
