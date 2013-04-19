class TracksController < ApplicationController
  
  def create
    @track = Track.new
    @track.attachment = uploaded_attachment
    
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
