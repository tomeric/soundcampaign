class MetricsController < ApplicationController
  
  before_action :require_user
  
  before_action :set_release_and_campaign
  
  before_action :require_release_owner
  
  def show
    
  end
  
  private
  
  def set_release_and_campaign
    @release  = Release.find_by id: params[:release_id]
    @campaign = @release.campaign
  end
  
end
