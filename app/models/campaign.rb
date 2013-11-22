class Campaign < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  has_many :recipients
  
  has_many :email_logs
  
  has_many :track_events,
    through: :release
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  validates :email_subject,
    presence: true
  
  validates :email_from,
    presence: true
  
  ### INSTANCE METHODS:
  
  def sent?
    sent_at.present?
  end
  
end
