class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  CANONICAL_HOSTNAME = 'soundcampaign.com'
  
  if Rails.env.production?
    before_action :redirect_to_canonical_hostname, unless: :on_canonical_hostname?
  end
  
  private
  
  def redirect_to_canonical_hostname
    canonical_url  = "#{request.protocol}#{CANONICAL_HOSTNAME}#{request.path}"
    redirect_to canonical_url, status: :moved_permanently
  end
  
  def on_canonical_hostname?
    request.host == CANONICAL_HOSTNAME
  end
  
  def hash_to_indexed_array(hash = {})
    array = []
    if hash.is_a?(Hash)
      hash.each do |index, values|
        array[index.to_i] = values
      end
    end
    array
  end
  
  def current_organization
    @current_organization ||= current_user.organization
  end
  helper_method :current_organization
  
  def unauthorized
    redirect_to new_user_session_url(return_to: request.url)
    return false
  end
  
  def require_label_owner
    unauthorized unless user_signed_in? &&
                        current_organization == @label.try(:organization)
  end
  
  def require_release_owner
    unauthorized unless user_signed_in? &&
                        current_organization == @release.try(:organization)
  end
  
  def require_contact_list_owner
    unauthorized unless user_signed_in? &&
                        current_organization == @contact_list.try(:organization)
  end
  
  def require_user
    unauthorized unless user_signed_in?
  end
end
