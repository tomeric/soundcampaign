class MockupsController < ApplicationController
  
  before_action :set_template, only: 'show'
  layout :pick_layout
  
  def index
    redirect_to root_url
  end
  
  def show
    render @template
  end
  
  private
  
  def set_template
    @template = params[:id].gsub(/[^a-z\-\_0-9]+/, '')
  end
  
  def pick_layout
    case @template
    when 'teaser'
      'teaser'
    when /^send_release_[0-9]$/
      'application'
    else
      'backend'
    end
  end
end
