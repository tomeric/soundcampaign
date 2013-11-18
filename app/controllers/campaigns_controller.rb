class CampaignsController < ApplicationController
  
  before_action :require_user
  
  before_action :set_release
  
  before_action :require_release_owner,
    except: %i[show]
  
  def new
    @label    = @release.label
    @campaign = @release.campaign || @release.build_campaign.tap do |campaign|
      campaign.name = @release.title
      campaign.body = @release.description
      if @label
        campaign.email_subject = "New release from #{@label.name}: #{@release.title}"
        campaign.email_from    = @label.contact_email
      else
        campaign.email_subject = "New release: #{@release.title}"
        campaign.email_from    = current_user.email
      end
    end
  end
  
  def create
    @campaign = @release.campaign || @release.build_campaign
    @campaign.attributes = campaign_attributes
    
    if @campaign.save
      redirect_to [@release, :campaign]
    else
      render :new
    end
  end
  
  def show
    @campaign = @release.campaign
    
    if @campaign.present?
      @label  = @release.label
      @tracks = @release.tracks
    else
      redirect_to [:new, @release, :campaign]
    end
  end
  
  def preview
    @campaign  = @release.campaign
    @receivers = (params[:receivers] || "").split(',').map(&:strip)
    
    @receivers.each do |receiver|
      recipient = @campaign.recipients.where(email: receiver).first_or_create
      
      mail = CampaignMailer.preview_campaign(@campaign, recipient)
      mail.deliver
    end
  end
  
  def edit
    @campaign = @release.campaign
  end
  
  def update
    @campaign = @release.campaign
    
    if @campaign.update_attributes(campaign_attributes)
      redirect_to :back
    else
      render :new
    end
  end
  
  private
  
  def campaign_attributes
    params.require(:campaign)
          .permit(:name, :email_subject, :email_from, :body)
  end
  
  def set_release
    @release = Release.find_by id: params[:release_id]
  end
  
end
