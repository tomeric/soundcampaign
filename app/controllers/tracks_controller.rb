class TracksController < ApplicationController
  
  before_filter :require_user, except: %i[show download stream]
  
  before_action :load_track,
    except: %i[new create destroy]
  
  before_action :load_release,
    only: %i[show download stream]
  
  before_action :require_release_owner_or_recipient,
    only: %i[show download stream]
  
  def show
    render json: @track.waveform
  end
  
  def download
    redirect_to @track.url(
      :download,
      response_content_disposition: "attachment; filename=#{CGI.escape(@track.attachment_file_name)}"
    )
  end
  
  def stream
    redirect_to @track.url(:streaming)
  end
  
  def create
    @track = current_organization.tracks.new
    @track.attachment = uploaded_attachment
    
    if params[:release_id].present?
      @track.release = current_organization.releases.find_by id: params[:release_id]
    end
    
    if @track.save
      template = render_to_string(partial: 'tracks/fields', locals: { track: @track })
      result   = @track.as_json
                       .merge(success: true, template: template)
      
      render json:   result,
             status: :created
    else
      render json: {
          name:   params[:qqfile],
          error:  error_messages(@track)
      },  status: :unprocessable_entity
    end
  end
  
  def destroy
    @track = current_organization.tracks.find_by id: params[:id]
    
    @track.archive
    @release = @track.release
    
    if @release.present?
      @release.tracks.each.with_index do |track, index|
        track.update_column :position, index + 1
      end
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to @release }
    end
  end
  
  private
  
  def load_track
    @track = Track.find_by id: params[:id]
  end
  
  def load_release
    @release = @track.release
  end
  
  def error_messages(object)
    object.errors.messages.map do |attribute, messages|
      "#{attribute} #{messages.to_sentence}"
    end.to_sentence
  end
  
  def uploaded_attachment
    params[:attachment].presence
  end
  
end
