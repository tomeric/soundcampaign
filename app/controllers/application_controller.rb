class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
  
  def unauthorized
    redirect_to new_user_session_url(return_to: request.url)
    return false
  end
  
  def require_user
    unauthorized unless user_signed_in?
  end
end
