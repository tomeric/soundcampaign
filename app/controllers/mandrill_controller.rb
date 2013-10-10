class MandrillController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  
  def index
    if user_signed_in?
      @events = MandrillEvent.all
    else
      head :ok
    end
  end
  
  def create
    mandrill_events = JSON.parse(params['mandrill_events'] || '[]')
    mandrill_events.each do |mandrill_event|
      MandrillEvent.create(json_payload: mandrill_event.to_json)
    end
    
    super
  end
end
