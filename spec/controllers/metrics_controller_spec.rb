require 'spec_helper'

describe MetricsController do
  let(:user)    { create :user                                     }
  let(:release) { create :release, organization: user.organization }
  
  describe 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get, :show, release_id: release.to_param }
    end
    
    context 'logged in' do
      let(:other_release) { create :release }
      
      before { sign_in user }
      
      it { should     have_access_to :get, :show, release_id: release.to_param       }
      it { should_not have_access_to :get, :show, release_id: other_release.to_param }
    end
  end
end
