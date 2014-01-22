class CampaignOpenEvent < ReleaseEvent
  
  ### ASSOCIATIONS:
  
  belongs_to :parent,
    class_name: EmailLog
  
  ### CALLBACKS:
  
  before_create :set_attributes_from_parent
  
  ### CLASS METHODS:
  
  def self.for(email_log)
    return unless email_log.opened_at?
    
    where(parent: email_log).first_or_create
  end
  
  ### INSTANCE METHODS:
  
  private
  
  def set_attributes_from_parent
    self.created_at = parent.opened_at
    self.recipient  = parent.recipient
    self.release    = parent.campaign.try(:release)
  end
  
end
