require 'spec_helper'

describe Subscriber do
  subject(:subscriber) { build :subscriber }
  
  it { should be_valid }
  
  context 'validations' do
    it { should allow_value('info@soundcampaign.com').for(:email) }
    it { should_not allow_value('not a valid e-mail').for(:email) }
  end
  
  context 'callbacks' do
    context 'on create' do
      it 'generates an invite code' do
        subscriber.invite_code = nil
        subscriber.save
        expect(subscriber.invite_code).to be_present
      end
      
      it "doesn't overwrite an invite code if it's already set" do
        existing_code = "#{Time.now.to_i}+#{rand(1000_000)}"
        subscriber.invite_code = existing_code
        subscriber.save
        expect(subscriber.invite_code).to eql existing_code
      end
    end
  end
  
  context 'instance methods' do
    describe '#invite_used?' do
      it "returns true if a user exists with the subscriber's invite_code" do
        subscriber.generate_invite_code
        create :user, invite_code: subscriber.invite_code
        expect(subscriber.invite_used?).to be_true
      end
      
      it "returns false if no user exists with the subscriber's invite_code" do
        subscriber.generate_invite_code
        User.where(invite_code: subscriber.invite_code).delete_all
        expect(subscriber.invite_used?).to be_false
      end
    end
  end
end
