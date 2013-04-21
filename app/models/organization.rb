class Organization < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  has_many :members,
    class_name: User
  
  has_many :labels
  
  has_many :artists
  
  has_many :releases
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
