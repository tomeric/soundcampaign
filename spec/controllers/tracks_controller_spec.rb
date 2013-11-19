require 'spec_helper'

describe TracksController do
  let(:user) { create :user }
  
  describe 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :post, :create }
    end
    
    context 'logged in' do
      before { sign_in user }
      
      it { should have_access_to :post, :create }
    end
  end
end
