require 'spec_helper'

describe LabelsController do
  let(:user)  { create :user                      }
  let(:label) { create :label,
                  organization: user.organization }
  
  context 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get,    :index                       }
      it { should_not have_access_to :get,    :new                         }
      it { should_not have_access_to :post,   :create                      }
      it { should_not have_access_to :get,    :show,    id: label.to_param }
      it { should_not have_access_to :get,    :edit,    id: label.to_param }
      it { should_not have_access_to :patch,  :update,  id: label.to_param }
      it { should_not have_access_to :delete, :destroy, id: label.to_param }
    end
    
    context 'logged in' do
      before { sign_in user }
      
      let(:owned_label) { label         }
      let(:other_label) { create :label }
      
      it { should     have_access_to :get,    :index                             }
      it { should     have_access_to :get,    :new                               }
      it { should     have_access_to :post,   :create                            }
      it { should     have_access_to :get,    :show,    id: owned_label.to_param }
      it { should_not have_access_to :get,    :show,    id: other_label.to_param }
      it { should     have_access_to :get,    :edit,    id: owned_label.to_param }
      it { should_not have_access_to :get,    :edit,    id: other_label.to_param }
      it { should     have_access_to :patch,  :update,  id: owned_label.to_param }
      it { should_not have_access_to :patch,  :update,  id: other_label.to_param }
      it { should     have_access_to :delete, :destroy, id: owned_label.to_param }
      it { should_not have_access_to :delete, :destroy, id: other_label.to_param }
    end
  end
  
  describe 'GET :index' do
    before { sign_in user }
    
    it "assigns the user's labels as @labels" do
      owned_label = label
      other_label = create :label
      
      get :index, {}
      expect(assigns[:labels]).to     include owned_label
      expect(assigns[:labels]).to_not include other_label
    end
  end
  
  describe 'GET :show' do
    before { sign_in user }
    
    it 'assigns the requested label as @label' do
      get :show, id: label.to_param
      expect(assigns[:label]).to eq label
    end
  end
  
  describe 'GET :new' do
    before { sign_in user }
    
    it 'assigns a new label as @label' do
      get :new
      expect(assigns[:label]).to be_a_new Label
    end
  end
  
  describe 'GET :edit' do
    before { sign_in user }
    
    it 'assigns the requested label as @label' do
      get :edit, id: label.to_param
      expect(assigns[:label]).to eq label
    end
  end
  
  describe 'POST :create' do
    before { sign_in user }
    
    let(:attributes) { attributes_for(:label) }
    
    context 'with valid params' do
      it 'creates a new Label' do
        expect {
          post :create, label: attributes
        }.to change {
          Label.count
        }.by +1
      end
      
      it "sets the organization of the created label to the logged in user's organization" do
        post :create, label: attributes
        organization = assigns[:label].organization
        expect(organization).to eq user.organization
      end
      
      it 'assigns a newly created label as @label' do
        post :create, label: attributes
        assigned_label = assigns[:label]
        expect(assigned_label).to be_a(Label)
        expect(assigned_label).to be_persisted
      end
      
      it 'redirects to the created label' do
        post :create, label: attributes
        expect(response).to redirect_to Label.last
      end
    end
    
    context 'with invalid params' do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        Label.any_instance.stub(:valid?).and_return(false)
      end
      
      it 'assigns a newly created but unsaved label as @label' do
        post :create, label: attributes
        expect(assigns[:label]).to be_a_new(Label)
      end
      
      it 're-renders the "new" template' do
        post :create, label: attributes
        expect(response).to render_template("new")
      end
    end
  end
  
  describe 'PATCH :update' do
    before { sign_in user }
    
    let(:attributes) { { name: 'updated name' } }
    
    context 'with valid params' do
      it "updates the requested label's attributes" do
        expect {
          patch :update, id: label.to_param, label: attributes
        }.to change {
          label.reload.name
        }.to 'updated name'
      end
      
      it 'assigns the requested label as @label' do
        patch :update, id: label.to_param, label: attributes
        expect(assigns[:label]).to eq label
      end
      
      it 'redirects to the label' do
        patch :update, id: label.to_param, label: attributes
        expect(response).to redirect_to label
      end
    end
    
    context 'with invalid params' do
      before do
        label # create the label first
        Label.any_instance.stub(:valid?).and_return(false)
      end
      
      it "doesn't update the requested label's attributes" do
        expect {
          patch :update, id: label.to_param, label: attributes
        }.to_not change {
          label.reload.name
        }
      end
      
      it "assigns the label as @label" do
        patch :update, id: label.to_param, label: attributes
        expect(assigns[:label]).to eq label
      end
      
      it 're-renders the "edit" template' do
        patch :update, id: label.to_param, label: attributes
        expect(response).to render_template("edit")
      end
    end
  end
  
  describe 'DELETE :destroy' do
    before { sign_in user }
    
    it 'destroys the requested label' do
      label # make sure it exists
      
      expect {
        delete :destroy, id: label.to_param
      }.to change {
        Label.count
      }.by -1
    end
    
    it 'redirects to the labels list' do
      delete :destroy, id: label.to_param
      expect(response).to redirect_to labels_url
    end
  end
  
  describe 'PUT :undestroy' do
    before do
      label.archive
      sign_in user
    end
    
    it 'unarchives an archived label' do
      expect {
        put :undestroy, id: label.to_param
      }.to change {
        Label.count
      }.by +1
    end
    
    it 'redirects to the edit label form' do
      put :undestroy, id: label.to_param
      expect(response).to redirect_to edit_label_url(label.to_param)
    end
  end
end
