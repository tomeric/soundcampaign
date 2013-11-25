class ReleasesController < ApplicationController
  
  layout 'backend'
  
  before_action :require_user,
    except: %i[show]
  
  before_action :set_release,
    except: %i[index new create]
  
  before_action :require_release_owner,
    except: %i[index new create show]
  
  before_action :require_release_owner_or_recipient,
    only: %i[show]
  
  def index
    @releases = current_organization.releases
                                    .includes(:campaign)
  end
  
  def show
    @label  = @release.label
    @tracks = @release.tracks
    
    if current_recipient
      @feedback = @release.feedbacks.by(current_recipient)
                          .first_or_initialize
    end
    
    render layout: 'release'
  end
  
  def new
    @release = Release.new
  end
  
  def edit
  end
  
  def create
    @release = Release.new(release_params)
    @release.organization = current_organization
    
    if @release.save
      redirect_to releases_url, notice: 'Release was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @release.update_attributes(release_params)
      redirect_to [:edit, @release], notice: 'Release was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @release.archive
    redirect_to releases_url,  alert: "You've just deleted \"#{@release.title}\". <a href='#{undestroy_release_path(@release)}' data-method='PUT'>Undo this</a>."
  end
  
  def undestroy
    @release.unarchive
    redirect_to @release
  end
  
  private
  
  def release_params
    params.require(:release)
          .permit(:title, :description, :catid,
                  :style, :cover, :label_id, :date,
                  { track_ids: [] },
                  { tracks_attributes: [[:id, :position, :title, :artist]] })
  end
  
  def set_release
    if action_name == 'show'
      @release = Release.find_by id: params[:id]
    elsif action_name == 'undestroy'
      @release = current_organization.releases.archived.find_by id: params[:id]
    else
      @release = current_organization.releases.find_by id: params[:id]
    end
  end
  
end
