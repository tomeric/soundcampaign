class ContactsController < ApplicationController
  
  layout 'backend'
  
  before_action :require_user
  
  before_action :set_contact_list
  
  before_action :require_contact_list_owner
  
  before_action :set_contact,
    only: %i[show edit update destroy]
  
  def index
    redirect_to @contact_list
  end
  
  def show
    redirect_to [:edit, @contact_list, @contact]
  end
  
  def new
    @contact = @contact_list.contacts.new
  end
  
  def create
    @contact = @contact_list.contacts.build(contact_params)
    
    if @contact.save
      redirect_to @contact_list, notice: 'Contact was successfully created and added in the list.'
    else
      render action: 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @contact.update(contact_params)
      redirect_to @contact_list, notice: 'Contact was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @contact.destroy
    redirect_to @contact_list, notice: 'Contact was successfully destroyed.'
  end
  
  private
  
  def contact_params
    params.require(:contact)
          .permit(:email, :name)
  end
  
  def set_contact_list
    @contact_list = ContactList.find(params[:contact_list_id])
  end
  
  def set_contact
    @contact = @contact_list.contacts.find(params[:id])
  end
  
end
