class SubscribersController < ApplicationController
  
  layout :pick_layout
  
  before_action :require_admin,
    except: %i[new create]
  
  def index
    @subscribers = Subscriber.order(created_at: :desc).all
  end
  
  def new
    if user_signed_in? && params[:force].blank?
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
  
  private
  
  def pick_layout
    case action_name.to_sym
    when :new, :create
      'teaser'
    else
      'backend'
    end
  end
end
