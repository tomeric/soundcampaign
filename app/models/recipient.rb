class Recipient < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :campaign
  
  belongs_to :contact
  
  has_many :email_logs
  
  ### VALIDATIONS:
  
  validates :secret,
    presence:   true,
    uniqueness: true
  
  ### CALLBACKS:
  
  before_validation :set_unique_secret, on: :create
  
  ### INSTANCE METHODS:
  
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
