class Feedback < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  belongs_to :recipient
  
  has_many :ratings,
    dependent: :destroy
  
  accepts_nested_attributes_for :ratings,
    allow_destroy: true,
    reject_if:     -> attributes {
      attributes['value'].blank?
    }
  
  ### VALIDATIONS:
  
  validates :body,
    presence: true
  
  validate :recipient_present
  
  ### SCOPES:
  
  scope :by, -> recipient {
    where(recipient_id: recipient.id)
  }
  
  ### INSTANCE METHODS:
  
  def rating_for(track)
    rating = ratings.for(track).first_or_initialize
    rating.track = track
    rating
  end
  
  private
  
  def recipient_present
    required = new_record? ? :recipient : :recipient_id
    errors.add :recipient, :blank unless send(required).present?
  end
  
end
