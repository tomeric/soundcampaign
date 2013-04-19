class Organization < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  has_many :members,
    class_name: User
  
  has_many :labels,
    through: :members
  
  has_many :artists,
    through: :members
  
  has_many :releases,
    through: :members
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
