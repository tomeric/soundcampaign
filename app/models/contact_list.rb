class ContactList < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :contacts
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true,
    uniqueness: {
      scope: :organization_id
    }
  
end
