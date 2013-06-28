require 'spec_helper'

describe Feedback do
  subject(:feedback) { build :feedback }
  
  it { should be_valid }
  
  context 'validations' do
    it { should validate_presence_of :body }
    
    it 'validates the presence of a subscriber or a user' do
      feedback.subscriber = nil
      feedback.user       = nil
      expect(feedback).to_not be_valid
      
      feedback.user = create :user
      expect(feedback).to be_valid
      
      feedback.user       = nil
      feedback.subscriber = create :subscriber
      expect(feedback).to be_valid
    end
  end
  
  context 'scopes' do
    describe '.by' do
      context 'with a user' do
        let(:user)             { create :user                                  }
        let(:feedback_by_user) { create :feedback, user: user, subscriber: nil }
        
        it 'includes feedback written by the given user' do
          expect(feedback_by_user).to be_in Feedback.by user
        end
        
        it 'excludes feedback written by another user' do
          other_user = create :user
          expect(feedback_by_user).to_not be_in Feedback.by other_user
        end
      end
      
      context 'with a subscriber' do
        let(:subscriber)             { create :subscriber                                  }
        let(:feedback_by_subscriber) { create :feedback, user: nil, subscriber: subscriber }
        
        it 'includes feedback written by the given subscriber' do
          expect(feedback_by_subscriber).to be_in Feedback.by subscriber
        end
        
        it 'excludes feedback written by another subscriber' do
          other_subscriber = create :subscriber
          expect(feedback_by_subscriber).to_not be_in Feedback.by other_subscriber
        end
      end
    end
  end
end
