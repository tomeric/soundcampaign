class CampaignsController < ApplicationController
  
  before_action :require_user
  
  before_action :set_release
  
  before_action :require_release_owner
  
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
    
    if @receivers.present?
      @receivers.each do |receiver|
        recipient = @campaign.recipients.where(email: receiver).first_or_create
        DeliverCampaignJob.perform_later(@campaign, recipient, true)
      end
      
      redirect_to [:edit, @release, :campaign]
    else
      render :preview
    end
  end
  
  def deliver
    @campaign = @release.campaign
    
    contact_list_ids = Array.wrap(params[:contact_lists]).flatten.compact
    @contact_lists   = current_organization.contact_lists.where(id: contact_list_ids)
    
    if @contact_lists.present?
      @campaign.send_to @contact_lists
      redirect_to [@release, :metrics]
    else
      render :deliver
    end
  end
  
  def edit
    @campaign = @release.campaign
    redirect_to [:new, @release, :campaign] if @campaign.blank?
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
