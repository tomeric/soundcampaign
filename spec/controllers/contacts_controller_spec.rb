require 'spec_helper'

describe ContactsController do
  let(:user)    { create :user                      }
  let(:list)    { create :contact_list,
                    organization: user.organization }
  let(:contact) { create :contact,
                    list: list                      }
  
  context 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get,    :index,   contact_list_id: list.to_param                       }
      it { should_not have_access_to :get,    :new,     contact_list_id: list.to_param                       }
      it { should_not have_access_to :post,   :create,  contact_list_id: list.to_param                       }
      it { should_not have_access_to :get,    :show,    contact_list_id: list.to_param, id: contact.to_param }
      it { should_not have_access_to :get,    :edit,    contact_list_id: list.to_param, id: contact.to_param }
      it { should_not have_access_to :patch,  :update,  contact_list_id: list.to_param, id: contact.to_param }
      it { should_not have_access_to :delete, :destroy, contact_list_id: list.to_param, id: contact.to_param }
    end
    
    context 'logged in' do
      before { sign_in user }
      
      let(:owned_list)    { list                 }
      let(:owned_contact) { contact              }
      let(:other_list)    { create :contact_list }
      let(:other_contact) { create :contact,
                              list: other_list   }
      
      it { should     have_access_to :get,    :index,   contact_list_id: owned_list.to_param                            }
      it { should_not have_access_to :get,    :index,   contact_list_id: other_list.to_param                            }
      it { should     have_access_to :get,    :new,     contact_list_id: owned_list.to_param                            }
      it { should_not have_access_to :get,    :new,     contact_list_id: other_list.to_param                            }
      it { should     have_access_to :post,   :create,  contact_list_id: owned_list.to_param                            }
      it { should_not have_access_to :post,   :create,  contact_list_id: other_list.to_param                            }
      it { should     have_access_to :get,    :show,    contact_list_id: owned_list.to_param, id: owned_contact.to_param }
      it { should_not have_access_to :get,    :show,    contact_list_id: other_list.to_param, id: other_contact.to_param }
      it { should     have_access_to :get,    :edit,    contact_list_id: owned_list.to_param, id: owned_contact.to_param }
      it { should_not have_access_to :get,    :edit,    contact_list_id: other_list.to_param, id: other_contact.to_param }
      it { should     have_access_to :patch,  :update,  contact_list_id: owned_list.to_param, id: owned_contact.to_param }
      it { should_not have_access_to :patch,  :update,  contact_list_id: other_list.to_param, id: other_contact.to_param }
      it { should     have_access_to :delete, :destroy, contact_list_id: owned_list.to_param, id: owned_contact.to_param }
      it { should_not have_access_to :delete, :destroy, contact_list_id: other_list.to_param, id: other_contact.to_param }
    end
  end
  
  describe 'GET :index' do
    before { sign_in user }
    
    it 'redirects to the contact list' do
      get :index, contact_list_id: list.to_param
      expect(response).to redirect_to contact_list_url(list)
    end
  end
  
  describe 'GET :show' do
    before { sign_in user }
    
    it 'redirects to the edit page' do
      get :show, contact_list_id: list.to_param, id: contact.to_param
      expect(response).to redirect_to edit_contact_list_contact_url(list, contact)
    end
  end
  
  describe 'GET :new' do
    before { sign_in user }
    
    it 'assigns the request contact list as @contact_list' do
      get :new, contact_list_id: list.to_param
      expect(assigns[:contact_list]).to eq list
    end
    
    it 'assigns a new contact as @contact' do
      get :new, contact_list_id: list.to_param
      expect(assigns[:contact]).to be_a_new Contact
    end
  end
  
  describe 'GET :edit' do
    before { sign_in user }
    
    it 'assigns the requested contact list as @contact_list' do
      get :edit, contact_list_id: list.to_param, id: contact.to_param
      expect(assigns[:contact_list]).to eq list
    end
    
    it 'assigns the requested contact as @contact' do
      get :edit, contact_list_id: list.to_param, id: contact.to_param
      expect(assigns[:contact]).to eq contact
    end
  end
  
  describe 'POST :create' do
    before { sign_in user }
    
    let(:attributes) { attributes_for(:contact).except(:contact_list_id) }
    
    context 'with valid params' do
      before do
        # Make sure list is created
        list
      end
      
      it 'creates a new contact in the contact list' do
        expect {
          post :create, contact_list_id: list.to_param, contact: attributes
        }.to change {
          list.contacts.count
        }.by +1
      end
      
      it 'assigns a newly created contact as @contact' do
        post :create, contact_list_id: list.to_param, contact: attributes
        assigned_contact = assigns[:contact]
        expect(assigned_contact).to be_a Contact
        expect(assigned_contact).to be_persisted
      end
      
      it 'redirects to the contact list' do
        post :create, contact_list_id: list.to_param, contact: attributes
        expect(response).to redirect_to list
      end
    end
    
    context 'with invalid params' do
      before do
        # Make sure list is created
        list
        # Trigger the behavior that occurs when invalid params are submitted
        Contact.any_instance.stub(:valid?).and_return(false)
      end
      
      it 'assigns a newly created but unsaved contact list as @contact_list' do
        post :create, contact_list_id: list.to_param, contact: attributes
        expect(assigns[:contact]).to be_a_new Contact
      end
      
      it 're-renders the "new" template' do
        post :create, contact_list_id: list.to_param, contact: attributes
        expect(response).to render_template 'new'
      end
    end
  end
  
  describe 'PATCH :update' do
    before { sign_in user }
    
    let(:attributes) { { first_name: 'updated first name' } }
    
    context 'with valid params' do
      it "updates the requested contact's attributes" do
        expect {
          patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        }.to change {
          contact.reload.first_name
        }.to 'updated first name'
      end
      
      it 'assigns the requested contact list as @contact_list' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(assigns[:contact_list]).to eq list
      end
      
      it 'assigns the requested contact as @contact' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(assigns[:contact]).to eq contact
      end
      
      it 'redirects to the contact list' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(response).to redirect_to list
      end
    end
    
    context 'with invalid params' do
      before do
        contact # create the contact_list first
        Contact.any_instance.stub(:valid?).and_return(false)
      end
      
      it "doesn't update the requested contact list's attributes" do
        expect {
          patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        }.to_not change {
          contact.reload.first_name
        }
      end
      
      it 'assigns the requested contact list as @contact_list' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(assigns[:contact_list]).to eq list
      end
      
      it 'assigns the requested contact as @contact' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(assigns[:contact]).to eq contact
      end
      
      it 're-renders the "edit" template' do
        patch :update, contact_list_id: list.to_param, id: contact.to_param, contact: attributes
        expect(response).to render_template 'edit'
      end
    end
  end
  
  describe 'DELETE :destroy' do
    before { sign_in user }
    
    it 'destroys the requested contact' do
      contact # make sure it exists
      
      expect {
        delete :destroy, contact_list_id: list.to_param, id: contact.to_param
      }.to change {
        list.contacts.count
      }.by -1
    end
    
    it 'redirects to the contact list' do
      delete :destroy, contact_list_id: list.to_param, id: contact.to_param
      expect(response).to redirect_to list
    end
  end
end
