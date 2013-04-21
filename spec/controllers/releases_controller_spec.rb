require 'spec_helper'

describe ReleasesController do
  let(:user)    { create :user                       }
  let(:label)   { create :label                      }
  let(:release) { create :release,
                    organization: user.organization,
                    label:        label              }
  
  context 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get,    :index                         }
      it { should_not have_access_to :get,    :new                           }
      it { should_not have_access_to :post,   :create                        }
      it { should_not have_access_to :get,    :show,    id: release.to_param }
      it { should_not have_access_to :get,    :edit,    id: release.to_param }
      it { should_not have_access_to :patch,  :update,  id: release.to_param }
      it { should_not have_access_to :delete, :destroy, id: release.to_param }
    end
    
    context 'logged in' do
      before { sign_in user }
      
      let(:owned_release) { release         }
      let(:other_release) { create :release }
      
      it { should     have_access_to :get,    :index                               }
      it { should     have_access_to :get,    :new                                 }
      it { should     have_access_to :post,   :create                              }
      it { should     have_access_to :get,    :show,    id: owned_release.to_param }
      it { should_not have_access_to :get,    :show,    id: other_release.to_param }
      it { should     have_access_to :get,    :edit,    id: owned_release.to_param }
      it { should_not have_access_to :get,    :edit,    id: other_release.to_param }
      it { should     have_access_to :patch,  :update,  id: owned_release.to_param }
      it { should_not have_access_to :patch,  :update,  id: other_release.to_param }
      it { should     have_access_to :delete, :destroy, id: owned_release.to_param }
      it { should_not have_access_to :delete, :destroy, id: other_release.to_param }
    end
  end
  
  describe 'GET :index' do
    before { sign_in user }
    
    it "assigns the user's releases as @releases" do
      owned_release = release
      other_release = create :release
      
      get :index, {}
      expect(assigns[:releases]).to     include owned_release
      expect(assigns[:releases]).to_not include other_release
    end
  end
  
  describe 'GET :show' do
    before { sign_in user }
    
    it 'assigns the requested release as @release' do
      get :show, id: release.to_param
      expect(assigns[:release]).to eq release
    end
  end
  
  describe 'GET :new' do
    before { sign_in user }
    
    it 'assigns a new release as @release' do
      get :new
      expect(assigns[:release]).to be_a_new Release
    end
  end
  
  describe 'GET :edit' do
    before { sign_in user }
    
    it 'assigns the requested release as @release' do
      get :edit, id: release.to_param
      expect(assigns[:release]).to eq release
    end
  end
  
  describe 'POST :create' do
    before { sign_in user }
    
    let(:attributes) { attributes_for(:release, label_id: label.id) }
    
    context 'with valid params' do
      it 'creates a new Release' do
        expect {
          post :create, release: attributes
        }.to change {
          Release.count
        }.by +1
      end
      
      it "sets the organization of the created release to the logged in user's organization" do
        post :create, release: attributes
        organization = assigns[:release].organization
        expect(organization).to eq user.organization
      end
      
      it 'assigns a newly created release as @release' do
        post :create, release: attributes
        assigned_release = assigns[:release]
        expect(assigned_release).to be_a(Release)
        expect(assigned_release).to be_persisted
      end
      
      it 'redirects to the releases list' do
        post :create, release: attributes
        expect(response).to redirect_to releases_url
      end
    end
    
    context 'with invalid params' do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        Release.any_instance.stub(:valid?).and_return(false)
      end
      
      it 'assigns a newly created but unsaved release as @release' do
        post :create, release: attributes
        expect(assigns[:release]).to be_a_new(Release)
      end
      
      it 're-renders the "new" template' do
        post :create, release: attributes
        expect(response).to render_template 'new'
      end
    end
  end
  
  describe 'PATCH :update' do
    before { sign_in user }
    
    let(:attributes) { { title: 'updated title' } }
    
    context 'with valid params' do
      it "updates the requested release's attributes" do
        expect {
          patch :update, id: release.to_param, release: attributes
        }.to change {
          release.reload.title
        }.to 'updated title'
      end
      
      it 'assigns the requested release as @release' do
        patch :update, id: release.to_param, release: attributes
        expect(assigns[:release]).to eq release
      end
      
      it 'redirects to the releases form' do
        patch :update, id: release.to_param, release: attributes
        expect(response).to redirect_to edit_release_url(release.to_param)
      end
    end
    
    context 'with invalid params' do
      before do
        release # create the release first
        Release.any_instance.stub(:valid?).and_return(false)
      end
      
      it "doesn't update the requested release's attributes" do
        expect {
          patch :update, id: release.to_param, release: attributes
        }.to_not change {
          release.reload.title
        }
      end
      
      it "assigns the release as @release" do
        patch :update, id: release.to_param, release: attributes
        expect(assigns[:release]).to eq release
      end
      
      it 're-renders the "edit" template' do
        patch :update, id: release.to_param, release: attributes
        expect(response).to render_template 'edit'
      end
    end
  end
  
  describe 'DELETE :destroy' do
    before { sign_in user }
    
    it 'destroys the requested release' do
      release # make sure it exists
      
      expect {
        delete :destroy, id: release.to_param
      }.to change {
        Release.count
      }.by -1
    end
    
    it 'redirects to the releases list' do
      delete :destroy, id: release.to_param
      expect(response).to redirect_to releases_url
    end
  end
end
