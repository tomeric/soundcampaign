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
  
  private
  
  def user_or_subscriber_present
    required_attributes = new_record? ? %i[user subscriber]
                                      : %i[user_id subscriber_id]
    
    unless required_attributes.map{ |attr| send(attr) }.any?(&:present?)
      errors.add :subscriber, :blank
    end
  end
  
end
