class FeedbacksController < ApplicationController
  
  before_action :load_release
  
  before_action :require_release_recipient,
    only: %i[create update]
    
  before_action :load_feedback,
    only: %i[create update]
  
  before_action :require_feedback_author,
    only: %i[update]
  
  def create
    update
  end
  
  def update
    if @feedback.update_attributes(feedback_params)
      redirect_to release_url(@release, secret: current_recipient.try(:secret))
    else
      @label  = @release.label
      @tracks = @release.tracks
      render 'releases/show', layout: 'release'
    end
  end
  
  private
  
  def require_feedback_author
    unauthorized unless feedback_author?
  end
  
  def feedback_author?
    current_recipient && @feedback.recipient == current_recipient
  end
  
  def feedback_params
    params.require(:feedback)
          .permit(:body, { ratings_attributes: [[:id, :track_id, :value]] })
  end
  
  def load_release
    @release = Release.find_by id: params[:release_id]
  end
  
  def load_feedback
    @feedback = case action_name
    when 'create'
      @release.feedbacks.by(current_recipient).first_or_initialize
    when 'update'
      @release.feedbacks.find(params[:id])
    end
  end
  
end
