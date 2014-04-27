require 'mandrill/web_hook'

class MandrillEventDecorator < Mandrill::WebHook::EventDecorator
  def message_id
    metadata['message_id'] || super
  end
  
  def timestamp
    ts = self['ts'].presence || msg['ts'].presence
    ts && Time.at(ts)
  end
  
  def metadata
    msg['metadata'] || {}
  end
end
