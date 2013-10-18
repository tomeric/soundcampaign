class Campaign < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  has_many :email_logs
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  validates :email_subject,
    presence: true
  
  validates :email_from,
    presence: true
  
end
