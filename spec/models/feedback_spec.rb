require 'spec_helper'

describe Feedback do
  subject(:feedback) { build :feedback }
  
  it { should be_valid }
  
  context 'validations' do
    it { should validate_presence_of :body }
    
    it 'validates the presence of a recipient' do
      feedback.recipient = nil
      expect(feedback).to_not be_valid
      
      feedback.recipient = create :recipient
      expect(feedback).to be_valid
    end
  end
  
  context 'scopes' do
    describe '.by' do
      let(:recipient)             { create :recipient                      }
      let(:other_recipient)       { create :recipient                      }
      let(:feedback_by_recipient) { create :feedback, recipient: recipient }
      
      it 'includes feedback written by the given recipient' do
        expect(feedback_by_recipient).to be_in Feedback.by recipient
      end
      
      it 'excludes feedback written by another recipient' do
        expect(feedback_by_recipient).to_not be_in Feedback.by other_recipient
      end
    end
  end
end
