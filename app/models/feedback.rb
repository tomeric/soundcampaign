class Feedback < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  belongs_to :user
  
  belongs_to :subscriber
  
  has_many :ratings
  accepts_nested_attributes_for :ratings,
    allow_destroy: true
  
  ### VALIDATIONS:
  
  validates :body,
    presence: true
  
  validate :user_or_subscriber_present
  
  ### SCOPES:
  
  scope :by, -> user_or_subscriber {
    if user_or_subscriber.is_a?(User)
      user = user_or_subscriber
      where(user_id: user.id)
    elsif user_or_subscriber.is_a?(Subscriber)
      subscriber = user_or_subscriber
      where(subscriber_id: subscriber.id)
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
  
  def user_or_subscriber_present
    required_attributes = new_record? ? %i[user subscriber]
                                      : %i[user_id subscriber_id]
    
    unless required_attributes.map{ |attr| send(attr) }.any?(&:present?)
      errors.add :subscriber, :blank
    end
  end
  
end
