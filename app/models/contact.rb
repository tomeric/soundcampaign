class Contact < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :contact_list
  
  ### VALIDATIONS:
  
  validates :email,
    presence: true,
    email:    true
  
end
