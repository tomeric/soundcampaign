class ContactListsController < ApplicationController
  
  layout 'backend'
  
  before_action :require_user
  
  before_action :set_contact_list,
    only: %i[show edit update destroy]
  
  before_action :require_contact_list_owner,
    only: %i[show edit update destroy]
  
  def index
    @contact_lists = current_organization.contact_lists
  end
  
  def show
  end
  
  def new
    @contact_list = ContactList.new
  end
  
  def edit
  end
  
  def create
    @contact_list = ContactList.new(contact_list_params)
    @contact_list.organization = current_organization
    
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
    @contact_list.destroy
    redirect_to contact_lists_url, notice: 'Contact list was successfully destroyed.'
  end
  
  private
  
  def set_contact_list
    @contact_list = ContactList.find(params[:id])
  end
  
  def contact_list_params
    params.require(:contact_list).permit(:name)
  end
end
