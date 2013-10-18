require 'mandrill/web_hook'

class MandrillEvent < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :email_log
  
  ### CALLBACKS:
  
  before_create :connect_to_email_log
  after_create  :process_event
  
  ### HOOKS:
  
  ##
  # Possible events: send, hard_bounce, soft_bounce, open,
  # click, spam, unsub, reject
  ##
  
  def handle_send(payload)
    email_log.sent_at = Time.now
    email_log.save!
  end
  
  def handle_soft_bounce(payload)
    handle_hard_bounce(payload)
  end
  
  def handle_hard_bounce(payload)
    email_log.bounced = true
    email_log.save!
  end
  
  def handle_open(payload)
    email_log.opened_at ||= Time.now
    email_log.save!
  end
  
  def handle_click(payload)
    email_log.clicked_at    ||= Time.now
    email_log.clicked_links = (email_log.clicked_links + payload.all_clicked_links).uniq
    email_log.save!
  end
  
  def handle_spam(payload)
    email_log.marked_as_spam = true
    email_log.save!
  end
  
  # def handle_unsub(payload); end
  # def handle_reject(payload); end
  
  ### INSTANCE METHODS:
  
  def connect_to_email_log
    if payload.message_id.present?
      self.email_log = EmailLog.find_by message_id: payload.message_id
    end
  end
  
  def payload
    @payload ||= begin
      json = begin
               JSON.parse(json_payload)
             rescue JSON::ParserError => e
               { }
             end
      
      MandrillEventDecorator[json]
    end
  end
  
  def process_event
    if email_log.present?
      params    = { 'mandrill_events' => "[#{json_payload}]" }
      processor = Mandrill::WebHook::Processor.new(params, self)
      processor.run!
    end
  end
  
end
