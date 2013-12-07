require 'spec_helper'

describe User do
  subject(:user) { build :user }
  
  it { should be_valid }
  
  context 'validations' do
    it { should allow_value('info@soundcampaign.com').for(:email) }
    it { should_not allow_value('not a valid e-mail').for(:email) }
  end
  
  context 'callbacks' do
    context 'on create' do
      it "creates a organization with the user's name" do
        user.organization = nil
        
        expect {
          user.save
        }.to change {
          Organization.count
        }.by +1
        
        expect(user.organization.name).to eql user.name
      end
      
      it "doesn't create an organization if it already exists" do
        user.organization = create :organization
        
        expect {
          user.save
        }.to_not change {
          Organization.count
        }
      end
    end
  end
  
  context 'instance methods' do
    describe '#has_role?' do
      it 'returns true if the user has a role with the given name' do
        user.roles << build(:role, name: 'admin', user: user)
        expect(user.has_role?('admin')).to be_true
      end
      
      it "returns false if the user doesn't have a role with the given name" do
        expect(user.has_role?('admin')).to be_false
      end
    end
  end
end
