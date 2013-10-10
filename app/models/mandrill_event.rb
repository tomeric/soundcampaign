require 'mandrill/web_hook'

class MandrillEvent < ActiveRecord::Base
  
  ### CALLBACKS:
  
  after_create :process_event
  
  ### HOOKS:
  
  ##
  # Possible events: send, hard_bounce, soft_bounce, open,
  # click, spam, unsub, reject
  ##
  
  def handle_send(payload)
    email_log(payload).try do |mail|
      mail.sent_at = Time.now
      mail.save!
    end
  end
  
  def handle_soft_bounce(payload)
    handle_hard_bounce(payload)
  end
  
  def handle_hard_bounce(payload)
    email_log(payload).try do |mail|
      mail.bounced = true
      mail.save!
    end
  end
  
  def handle_open(payload)
    email_log(payload).try do |mail|
      mail.opened_at ||= Time.now
      mail.save!
    end
  end
  
  def handle_click(payload)
    email_log(payload).try do |mail|
      mail.clicked_at    ||= Time.now
      mail.clicked_links = (mail.clicked_links + payload.all_clicked_links).uniq
      mail.save!
    end
  end
  
  def handle_spam(payload)
    email_log(payload).try do |mail|
      mail.marked_as_spam = true
      mail.save!
    end
  end
  
  ### INSTANCE METHODS:
  
  def process_event
    params    = { 'mandrill_events' => "[#{json_payload}]" }
    processor = Mandrill::WebHook::Processor.new(params, self)
    processor.run!
  end
  
  private
  
  def email_log(payload)
    EmailLog.find_by message_id: payload.message_id
  end
  
end
