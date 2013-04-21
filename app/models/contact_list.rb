class ContactList < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true,
    uniqueness: {
      scope: :organization_id
    }
  
end
