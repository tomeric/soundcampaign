class Campaign < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  validates :email_subject,
    presence: true
  
  validates :email_from,
    presence: true
  
end
