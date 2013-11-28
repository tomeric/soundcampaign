class RegistrationsController < Devise::RegistrationsController
  
  def new
    Rails.env.production? ? registration_closed : super
  end
  
  def create
    Rails.env.production? ? registration_closed : super
  end
  
  private
  
  def registration_closed
    render 'registration_closed', layout: 'teaser', status: :forbidden
  end
  
end
