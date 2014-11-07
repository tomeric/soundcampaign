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
  
  def send_to(*collection)
    collection = collection.flatten.compact
    return false unless collection.present?
    
    if sent_at?
      collection.each do |list|
        SendCampaignReminderJob.perform_later(self, list)
      end
    else
      collection.each do |list|
        SendCampaignJob.perform_later(self, list)
      end
      
      self.sent_at = Time.now
      save!
    end
  end
  
end
