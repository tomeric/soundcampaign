require 'spec_helper'

describe FeedbacksController do
  let(:user)      { create :user                                              }
  let(:release)   { create :release,   organization: user.organization        }
  let(:campaign)  { create :campaign,  release:   release                     }
  let(:recipient) { create :recipient, campaign:  campaign                    }
  let(:feedback)  { create :feedback,  recipient: recipient, release: release }
  
  describe 'authorization' do
    let(:other_release)  { create :release                    }
    let(:other_feedback) { create :feedback, release: release }
    
    context 'logged out' do
      it { should_not have_access_to :post,  :create, release_id: release.to_param                        }
      it { should_not have_access_to :patch, :update, release_id: release.to_param, id: feedback.to_param }
    end
    
    context 'as a release owner' do
      before { sign_in user }
      
      it { should_not have_access_to :post,  :create, release_id: release.to_param                        }
      it { should_not have_access_to :patch, :update, release_id: release.to_param, id: feedback.to_param }
    end
    
    context 'as a recipient' do
      let(:other_feedback) { create :feedback, release: release }
      
      it { should     have_access_to :post,  :create, release_id: release.to_param,       secret: recipient.secret                     }
      it { should_not have_access_to :post,  :create, release_id: other_release.to_param, secret: recipient.secret                     }
      it { should     have_access_to :patch, :update, release_id: release.to_param,       secret: recipient.secret, id: feedback       }
      it { should_not have_access_to :patch, :update, release_id: release.to_param,       secret: recipient.secret, id: other_feedback }
    end
  end
end
