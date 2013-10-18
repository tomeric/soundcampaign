require 'mandrill/web_hook'

class MandrillEventDecorator < Mandrill::WebHook::EventDecorator
  def message_id
    metadata['message_id'] || super
  end
  
  def timestamp
    msg['ts'] && Time.at(msg['ts'])
  end
  
  def metadata
    msg['metadata'] || {}
  end
end
