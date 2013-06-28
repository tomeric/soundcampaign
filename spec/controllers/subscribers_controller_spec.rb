require 'spec_helper'

describe SubscribersController do
  describe 'GET :index' do
    it 'redirects to the new subscriber page' do
      get :index
      expect(response).to redirect_to new_subscriber_url
    end
  end
  
  describe 'GET :new' do
    it "redirects to the user's labels if logged in and the user has no labels" do
      user = create :user
      sign_in user
      
      get :new
      expect(response).to redirect_to labels_url
    end
    
    it "redirects to the user's releases if logged in and the user has a label" do
      user  = create :user
      label = create :label, organization: user.organization
      sign_in user
      
      get :new
      expect(response).to redirect_to releases_url
    end
    
    it 'assigns a new subscriber as @subscriber' do
      get :new
      expect(assigns[:subscriber]).to be_a_new Subscriber
    end
  end
  
  describe 'POST :create' do
    let(:attributes) { { email: 'info@soundcampaign.com' } }
    
    context 'with valid params' do
      it 'creates a subscriber with the given email' do
        expect {
          post :create, attributes
        }.to change {
          Subscriber.count
        }.by +1
        
        subscriber = Subscriber.last
        expect(subscriber.email).to eq attributes[:email]
      end
      
      it "doesn't create duplicate subscribers" do
        post :create, attributes
        
        expect {
          post :create, attributes
        }.to_not change {
          Subscriber.count
        }
      end
      
      it 'renders the "create" template' do
        post :create, attributes
        expect(response).to render_template 'create'
      end
    end
    
    context 'with invalid params' do
      before { Subscriber.any_instance.stub(:valid?).and_return(false) }
      
      it 're-renders the "new" template' do
        post :create, attributes
        expect(response).to render_template 'new'
      end
    end
  end
end
