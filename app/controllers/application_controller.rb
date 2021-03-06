class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  if Rails.env.production?
    before_action :redirect_to_canonical_hostname, unless: :on_canonical_hostname?
  end
  
  before_filter :configure_permitted_devise_parameters, if: :devise_controller?
  
  private
  
  def configure_permitted_devise_parameters
    {
      sign_in:        %i[password remember_me],
      sign_up:        %i[password password_confirmation name invite_code],
      account_update: %i[password password_confirmation current_password name invite_code]
    }.each do |action, permitted|
      devise_parameter_sanitizer.for(action) do |params|
        auth_keys = resource_class.authentication_keys.respond_to?(:keys) ?
                      resource_class.authentication_keys.keys :
                      resource_class.authentication_keys
        
        attributes = auth_keys + permitted
        params.permit *attributes
      end
    end
  end
  
  def redirect_to_canonical_hostname
    canonical_url  = "#{request.protocol}#{Settings.canonical_hostname}#{request.path}"
    redirect_to canonical_url, status: :moved_permanently
  end
  
  def on_canonical_hostname?
    request.host == Settings.canonical_hostname
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
    @current_organization ||= current_user.try(:organization)
  end
  helper_method :current_organization
  
  def current_recipient
    return false unless @release.try(:campaign).present?
    @current_recipient ||= @release.campaign.recipients.find_by secret: params[:secret]
  end
  helper_method :current_recipient
  
  def unauthorized
    redirect_to new_user_session_url(return_to: request.url)
    return false
  end
  
  def require_admin
    unauthorized unless user_signed_in? && current_user.has_role?('admin')
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
  
  def require_release_recipient
    unauthorized unless current_recipient.present?
  end
  
  def require_release_owner_or_recipient
    unauthorized unless current_recipient.present? || (
                          user_signed_in? &&
                          current_organization == @release.try(:organization)
                        )
  end
end
