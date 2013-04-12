class ReleasesController < ApplicationController
  
  layout 'backend'
  
  def index
    @releases = current_user.releases.group_by(&:label)
  end
  
  def new
    @release = Release.new
  end
  
  def create
    @release = Release.new(release_params)
    @release.owner = current_user
    
    if @release.save
      redirect_to releases_url
    else
      render 'new'
    end
  end
  
  private
  
  def release_params
    params.require(:release)
  end
  
end
