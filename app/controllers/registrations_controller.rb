class RegistrationsController < Devise::RegistrationsController
  
  before_action :require_invite_code,
    only: %i[new create]
  
  private
  
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
