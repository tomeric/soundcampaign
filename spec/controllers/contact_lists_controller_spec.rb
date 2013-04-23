require 'spec_helper'

describe ContactListsController do
  let(:user) { create :user                      }
  let(:list) { create :contact_list,
                 organization: user.organization }
  
  context 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get,    :index                      }
      it { should_not have_access_to :get,    :new                        }
      it { should_not have_access_to :post,   :create                     }
      it { should_not have_access_to :get,    :show,    id: list.to_param }
      it { should_not have_access_to :get,    :edit,    id: list.to_param }
      it { should_not have_access_to :patch,  :update,  id: list.to_param }
      it { should_not have_access_to :delete, :destroy, id: list.to_param }
    end
    
    context 'logged in' do
      before { sign_in user }
      
      let(:owned_list) { list                 }
      let(:other_list) { create :contact_list }
      
      it { should     have_access_to :get,    :index                            }
      it { should     have_access_to :get,    :new                              }
      it { should     have_access_to :post,   :create                           }
      it { should     have_access_to :get,    :show,    id: owned_list.to_param }
      it { should_not have_access_to :get,    :show,    id: other_list.to_param }
      it { should     have_access_to :get,    :edit,    id: owned_list.to_param }
      it { should_not have_access_to :get,    :edit,    id: other_list.to_param }
      it { should     have_access_to :patch,  :update,  id: owned_list.to_param }
      it { should_not have_access_to :patch,  :update,  id: other_list.to_param }
      it { should     have_access_to :delete, :destroy, id: owned_list.to_param }
      it { should_not have_access_to :delete, :destroy, id: other_list.to_param }
    end
  end
  
  describe 'GET :index' do
    before { sign_in user }
    
    it "assigns the user organization's contact lists as @contact_lists" do
      owned_list = list
      other_list = create :contact_list
      
      get :index, {}
      expect(assigns[:contact_lists]).to     include owned_list
      expect(assigns[:contact_lists]).to_not include other_list
    end
  end
  
  describe 'GET :show' do
    before { sign_in user }
    
    it 'assigns the requested contact list as @contact_list' do
      get :show, id: list.to_param
      expect(assigns[:contact_list]).to eq list
    end
    
    it "assigns the requested contact list's contacts as @contacts" do
      create :contact, list: list
      contacts = list.contacts
      get :show, id: list.to_param
      expect(assigns[:contacts]).to eq contacts
    end
  end
  
  describe 'GET :new' do
    before { sign_in user }
    
    it 'assigns a new contact list as @contact_list' do
      get :new
      expect(assigns[:contact_list]).to be_a_new ContactList
    end
  end
  
  describe 'GET :edit' do
    before { sign_in user }
    
    it 'assigns the requested contact list as @contact_list' do
      get :edit, id: list.to_param
      expect(assigns[:contact_list]).to eq list
    end
  end
  
  describe 'POST :create' do
    before { sign_in user }
    
    let(:attributes) { attributes_for(:contact_list) }
    
    context 'with valid params' do
      it 'creates a new contact list' do
        expect {
          post :create, contact_list: attributes
        }.to change {
          ContactList.count
        }.by +1
      end
      
      it "sets the organization of the created contact list to the logged in user's organization" do
        post :create, contact_list: attributes
        organization = assigns[:contact_list].organization
        expect(organization).to eq user.organization
      end
      
      it 'assigns a newly created contact list as @contact_list' do
        post :create, contact_list: attributes
        assigned_list = assigns[:contact_list]
        expect(assigned_list).to be_a ContactList
        expect(assigned_list).to be_persisted
      end
      
      it 'redirects to the created contact list' do
        post :create, contact_list: attributes
        expect(response).to redirect_to ContactList.last
      end
    end
    
    context 'with invalid params' do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        ContactList.any_instance.stub(:valid?).and_return(false)
      end
      
      it 'assigns a newly created but unsaved contact list as @contact_list' do
        post :create, contact_list: attributes
        expect(assigns[:contact_list]).to be_a_new ContactList
      end
      
      it 're-renders the "new" template' do
        post :create, contact_list: attributes
        expect(response).to render_template("new")
      end
    end
  end
  
  describe 'PATCH :update' do
    before { sign_in user }
    
    let(:attributes) { { name: 'updated name' } }
    
    context 'with valid params' do
      it "updates the requested contact list's attributes" do
        expect {
          patch :update, id: list.to_param, contact_list: attributes
        }.to change {
          list.reload.name
        }.to 'updated name'
      end
      
      it 'assigns the requested contact list as @contact_list' do
        patch :update, id: list.to_param, contact_list: attributes
        expect(assigns[:contact_list]).to eq list
      end
      
      it 'redirects to the contact list' do
        patch :update, id: list.to_param, contact_list: attributes
        expect(response).to redirect_to list
      end
    end
    
    context 'with invalid params' do
      before do
        list # create the contact_list first
        ContactList.any_instance.stub(:valid?).and_return(false)
      end
      
      it "doesn't update the requested contact list's attributes" do
        expect {
          patch :update, id: list.to_param, contact_list: attributes
        }.to_not change {
          list.reload.name
        }
      end
      
      it "assigns the contact list as @contact_list" do
        patch :update, id: list.to_param, contact_list: attributes
        expect(assigns[:contact_list]).to eq list
      end
      
      it 're-renders the "edit" template' do
        patch :update, id: list.to_param, contact_list: attributes
        expect(response).to render_template 'edit'
      end
    end
  end
  
  describe 'DELETE :destroy' do
    before { sign_in user }
    
    it 'destroys the requested contact list' do
      list # make sure it exists
      
      expect {
        delete :destroy, id: list.to_param
      }.to change {
        ContactList.count
      }.by -1
    end
    
    it 'redirects to the contact lists' do
      delete :destroy, id: list.to_param
      expect(response).to redirect_to contact_lists_url
    end
  end
end
