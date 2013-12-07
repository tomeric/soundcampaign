class RegistrationsController < Devise::RegistrationsController
  
  before_action :require_invite_code,
    only: %i[new create]
  
  before_action :update_sanitized_params
  
  private
  
  
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :name, :invite_code, :password, :password_confirmation) }
  end
  
  def invite_code
    @invite_code ||= (params[:invite_code] || params[:user].try(:[], :invite_code)).presence
  end
  helper_method :invite_code
  
  def require_invite_code
    @subscriber = Subscriber.find_by invite_code: invite_code
    
    if @subscriber.blank? || @subscriber.invite_used?
      render 'registration_closed',
        layout: 'teaser',
        status: :forbidden
      
      return false
    end
  end
  
end
