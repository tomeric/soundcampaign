class FeedbacksController < ApplicationController
  
  before_action :require_user
  before_action :load_release
  
  def create
    update
  end
  
  def update
    @feedback = @release.feedbacks.by(current_user)
                        .first_or_initialize
    
    if @feedback.update_attributes(feedback_params)
      redirect_to @release
    else
      @label    = @release.label
      @tracks   = @release.tracks
      render 'releases/show'
    end
  end
  
  private
  
  def feedback_params
    params.require(:feedback)
          .permit(:body,
                  { ratings_attributes: [[:id, :track_id, :value]] })
  end
  
  def load_release
    @release = Release.find(params[:release_id])
  end
  
end
