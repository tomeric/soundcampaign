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
end
