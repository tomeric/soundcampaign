class Organization < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  has_many :members,
    class_name: User
  
  has_many :artists
  
  has_many :contact_lists
  
  has_many :contacts,
    through: :contact_lists
  
  has_many :labels
  
  has_many :releases
  
  has_many :tracks
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
