class Contact < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  belongs_to :list,
    class_name:  ContactList,
    foreign_key: :contact_list_id
  
  ### VALIDATIONS:
  
  validates :email,
    presence: true,
    email:    true
  
end
