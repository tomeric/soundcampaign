class CoversController < ApplicationController
  
  before_filter :require_user
  
  def create
    if params[:release_id].present?
      @coverable = current_organization.releases.find_by id: params[:release_id]
    elsif params[:artist_id].present?
      @coverable = current_organization.artists.find_by id: params[:artist_id]
    elsif params[:label_id].present?
      @coverable = current_organization.labels.find_by id: params[:label_id]
    end
    
    if @coverable
      @cover = @coverable.cover || @coverable.build_cover
    else
      @cover = current_organization.covers.new
    end
    
    @cover.attachment = uploaded_attachment
    
    if @cover.save
      result = @cover.as_json.merge(success: true, thumbnailUrl: @cover.url(:thumbnail))
      
      render json:   result,
             status: :created
    else
      render json: {
          name:   params[:qqfile],
          error:  error_messages(@cover)
      },  status: :unprocessable_entity
    end
  end
  
  private
  
  def error_messages(object)
    object.errors.messages.map do |attribute, messages|
      "#{attribute} #{messages.to_sentence}"
    end.to_sentence
  end
  
  def uploaded_attachment
    params[:attachment].presence
  end
  
end
