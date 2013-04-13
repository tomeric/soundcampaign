class ReleasesController < ApplicationController
  
  layout 'backend'
  
  before_action :require_user
  
  before_action :set_release,
    only: %i[show edit update destroy]
  
  before_action :require_release_owner,
    only: %i[show edit update destroy]
  
  def index
    @releases = current_user.releases
  end
  
  def show
  end
  
  def new
    @release = Release.new
  end
  
  def edit
  end
  
  def create
    @release = Release.new(release_params)
    @release.owner = current_user
    
    if @release.save
      redirect_to releases_url, notice: 'Release was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @release.update(release_params)
      redirect_to releases_url, notice: 'Release was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @release.destroy
    redirect_to releases_url, notice: 'Release was successfully destroyed.'
  end
  
  private
  
  def release_params
    params.require(:release)
          .permit(:title, :description, :catid,
                  :style, :cover, :label_id, :date)
  end
  
  def set_release
    @release = Release.find(params[:id])
  end
  
end
