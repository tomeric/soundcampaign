class EmailLog < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :recipient,
    polymorphic: true
  
  belongs_to :campaign
  
  ### CALLBACKS:
  
  before_save :connect_to_campaign
  
  ### CLASS METHODS:
  
  def self.delivered_email(message)
    find_or_initialize_by(message_id: message.message_id).tap do |mail|
      mail.subject = message.subject
      mail.to      = Array.wrap(message.to)
      mail.from    = Array.wrap(message.from).first
      mail.body    = message.body.to_s
    end.save
  end
  
  ### INSTANCE METHODS:
  
  def connect_to_campaign
    if match = message_id.match(/campaign:([0-9]+)\+/) 
      self.campaign = Campaign.find_by id: match[1].to_i
    end
  end
  
end
