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
    MandrillEvent.create(json_payload: params['mandrill_events'] || '[]')
    super
  end
end
