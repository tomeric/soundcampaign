class Feedback < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  belongs_to :user
  
  belongs_to :recipient
  
  has_many :ratings
  accepts_nested_attributes_for :ratings,
    allow_destroy: true
  
  ### VALIDATIONS:
  
  validates :body,
    presence: true
  
  validate :user_or_recipient_present
  
  ### SCOPES:
  
  scope :by, -> user_or_recipient {
    if user_or_recipient.is_a?(User)
      user = user_or_recipient
      where(user_id: user.id)
    elsif user_or_recipient.is_a?(Recipient)
      recipient = user_or_recipient
      where(recipient_id: recipient.id)
    else
      none
    end
  }
  
  ### INSTANCE METHODS:
  
  def rating_for(track)
    rating = ratings.for(track).first_or_initialize
    rating.track = track
    rating
  end
  
  private
  
  def user_or_recipient_present
    required_attributes = new_record? ? %i[user recipient]
                                      : %i[user_id recipient_id]
    
    unless required_attributes.map{ |attr| send(attr) }.any?(&:present?)
      errors.add :recipient, :blank
    end
  end
  
end
