require 'spec_helper'

describe Feedback do
  subject(:feedback) { build :feedback }
  
  it { should be_valid }
  
  context 'validations' do
    it { should validate_presence_of :body }
    
    it 'validates the presence of a recipient or a user' do
      feedback.recipient = nil
      feedback.user      = nil
      expect(feedback).to_not be_valid
      
      feedback.user = create :user
      expect(feedback).to be_valid
      
      feedback.user      = nil
      feedback.recipient = create :recipient
      expect(feedback).to be_valid
    end
  end
  
  context 'scopes' do
    describe '.by' do
      context 'with a user' do
        let(:user)             { create :user                                 }
        let(:feedback_by_user) { create :feedback, user: user, recipient: nil }
        
        it 'includes feedback written by the given user' do
          expect(feedback_by_user).to be_in Feedback.by user
        end
        
        it 'excludes feedback written by another user' do
          other_user = create :user
          expect(feedback_by_user).to_not be_in Feedback.by other_user
        end
      end
      
      context 'with a recipient' do
        let(:recipient)             { create :recipient                                 }
        let(:feedback_by_recipient) { create :feedback, user: nil, recipient: recipient }
        
        it 'includes feedback written by the given recipient' do
          expect(feedback_by_recipient).to be_in Feedback.by recipient
        end
        
        it 'excludes feedback written by another recipient' do
          other_recipient = create :recipient
          expect(feedback_by_recipient).to_not be_in Feedback.by other_recipient
        end
      end
    end
  end
end
