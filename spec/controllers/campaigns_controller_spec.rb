require 'spec_helper'

describe CampaignsController do
  let(:user)     { create :user                                      }
  let(:release)  { create :release,  organization: user.organization }
  let(:campaign) { create :campaign, release: release                }
  
  describe 'authorization' do
    context 'logged out' do
      it { should_not have_access_to :get,   :new,     release_id: release.to_param }
      it { should_not have_access_to :post,  :create,  release_id: release.to_param }
      it { should_not have_access_to :get,   :show,    release_id: release.to_param }
      it { should_not have_access_to :get,   :edit,    release_id: release.to_param }
      it { should_not have_access_to :patch, :update,  release_id: release.to_param }
      it { should_not have_access_to :post,  :preview, release_id: release.to_param }
    end
    
    context 'logged in' do
      let(:other_release)  { create :release                          }
      let(:other_campaign) { create :campaign, release: other_release }
      
      before { sign_in user }
      
      it { should     have_access_to :get,   :new,     release_id: release.to_param       }
      it { should_not have_access_to :get,   :new,     release_id: other_release.to_param }
      it { should     have_access_to :post,  :create,  release_id: release.to_param       }
      it { should_not have_access_to :post,  :create,  release_id: other_release.to_param }
      it { should     have_access_to :get,   :show,    release_id: release.to_param       }
      it { should_not have_access_to :get,   :show,    release_id: other_release.to_param }
      it { should     have_access_to :get,   :edit,    release_id: release.to_param       }
      it { should_not have_access_to :get,   :edit,    release_id: other_release.to_param }
      it { should     have_access_to :patch, :update,  release_id: release.to_param       }
      it { should_not have_access_to :patch, :update,  release_id: other_release.to_param }
      it { should     have_access_to :post,  :preview, release_id: release.to_param       }
      it { should_not have_access_to :post,  :preview, release_id: other_release.to_param }
    end
  end
end
