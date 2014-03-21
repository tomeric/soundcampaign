class FeedbackEvent < ReleaseEvent
  
  ### ASSOCIATIONS:
  
  belongs_to :parent,
    class_name: Feedback
  
  ### CALLBACKS:
  
  before_create :set_attributes_from_parent
  
  ### CLASS METHODS:
  
  def self.for(feedback_or_id)
    feedback = feedback_or_id.is_a?(Feedback)  ?
                 feedback_or_id                :
                 Feedback.find(feedback_or_id)
    where(parent: feedback).first_or_create
  end
  
  ### INSTANCE METHODS:
  
  private
  
  def set_attributes_from_parent
    self.created_at = parent.created_at
    self.recipient  = parent.recipient
    self.release    = parent.release
  end
  
end
