class Recipient < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :campaign
  
  belongs_to :contact
  
  has_many :email_logs
  
  has_many :release_events
  
  ### VALIDATIONS:
  
  validates :secret,
    presence:   true,
    uniqueness: true
  
  ### CALLBACKS:
  
  before_validation :set_unique_secret, on: :create
  
  ### INSTANCE METHODS:
  
  def name
    contact.try(:name).presence || contact.try(:email).presence || email.presence
  end
  
  def clicked_link?
    clicked_email = email_logs.any? do |log|
      log.clicked_at.present?
    end
    
    used_release = release_events.any? do |evt|
      evt.is_a?(TrackPlayEvent) ||
      evt.is_a?(FeedbackEvent)
    end
    
    clicked_email || used_release
  end
  
  def set_unique_secret
    seeds = []
    seeds << (Time.now.to_f * 1000_000.0).to_i # Current time in microseconds
    seeds << rand(1000_000_000)
    seeds << email
    
    # Generate a *unique* secret that has never been used before:
    self.secret = Digest::SHA256.hexdigest seeds.join('+')
    set_unique_secret if Recipient.where(secret: secret).exists?
    
    secret
  end
  
end
