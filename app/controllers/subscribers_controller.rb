class SubscribersController < ApplicationController
  layout 'teaser'
  
  def index
    redirect_to new_subscriber_url
  end
  
  def new
    if user_signed_in?
      if current_organization.labels.count > 0
        redirect_to releases_url
      else
        redirect_to labels_url
      end
    else
      @subscriber = Subscriber.new
    end
  end
  
  def create
    @email      = params[:email].presence
    @subscriber = Subscriber.new(email: @email)
    
    if Subscriber.find_by_email(@email)
      render 'create'
    elsif @subscriber.save
      render 'create', status: :created
    else
      render 'new',    status: :unprocessable_entity
    end
  end
end
