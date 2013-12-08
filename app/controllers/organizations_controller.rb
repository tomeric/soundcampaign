class OrganizationsController < ApplicationController
  
  before_filter :require_admin
  
  def index
    @organizations = Organization.order(created_at: :desc).all
  end
  
end
