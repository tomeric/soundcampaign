class CampaignOpenEvent < ReleaseEvent
  
  ### ASSOCIATIONS:
  
  belongs_to :parent,
    class_name: EmailLog
  
  ### CALLBACKS:
  
  before_create :set_attributes_from_parent
  
  ### CLASS METHODS:
  
  def self.for(email_log_or_id)
    email_log = email_log_or_id.is_a?(EmailLog) ?
                  email_log_or_id               :
                  EmailLog.find(email_log_or_id)
    
    if email_log.try(:opened_at?)
      where(parent: email_log).first_or_create
    end
  end
  
  ### INSTANCE METHODS:
  
  private
  
  def set_attributes_from_parent
    self.created_at = parent.opened_at
    self.recipient  = parent.recipient
    self.release    = parent.campaign.try(:release)
  end
  
end
