class ContactListsController < ApplicationController
  
  layout 'backend'
  
  before_action :require_user
  
  before_action :set_contact_list,
    only: %i[show edit update destroy undestroy]
  
  before_action :require_contact_list_owner,
    only: %i[show edit update destroy undestroy]
  
  def index
    @contact_lists = current_organization.contact_lists.order(name: :asc)
  end
  
  def show
    @contacts = @contact_list.contacts
    
    respond_to do |format|
      format.html do
        @contacts = @contacts.order(name: :asc) # Add pagination later
      end
      
      format.csv do
        @contacts = @contacts.order(id: :asc)
      end
    end
  end
  
  def new
    @contact_list = current_organization.contact_lists.new
  end
  
  def edit
  end
  
  def create
    @contact_list = current_organization.contact_lists.new(contact_list_params)
    
    if @contact_list.save
      redirect_to @contact_list, notice: 'Contact list was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @contact_list.update(contact_list_params)
      redirect_to @contact_list, notice: 'Contact list was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @contact_list.archive
    redirect_to contact_lists_url, alert: "You've just deleted \"#{@contact_list.name}\". <a href='#{undestroy_contact_list_path(@contact_list)}' data-method='PUT'>Undo this</a>."
  end
  
  def undestroy
    @contact_list.unarchive
    redirect_to contact_lists_url
  end
  
  private
  
  def set_contact_list
    if action_name == 'undestroy'
      @contact_list = current_organization.contact_lists.archived.find_by(id: params[:id])
    else
      @contact_list = current_organization.contact_lists.find_by(id: params[:id])
    end
  end
  
  def contact_list_params
    params.require(:contact_list).permit(:name)
  end
end
