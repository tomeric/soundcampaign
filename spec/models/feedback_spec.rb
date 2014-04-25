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
  
  context 'callbacks' do
    context 'on save' do
      it 'tries to create a FeedbackEvent in the background' do
        expect(FeedbackEvent).to receive(:delay).and_return(FeedbackEvent)
        expect(FeedbackEvent).to receive(:for).with(kind_of(Integer))
        feedback.save
      end
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
  
  context 'nested attributes' do
    let(:feedback) { create :feedback                         }
    let(:track)    { create :track, release: feedback.release }
    
    context 'ratings' do
      it 'accepts rating attributes if the value is present' do
        new_attributes = {
          ratings_attributes: [{
            track_id: track.id,
            value:    10
          }]
        }
        
        feedback.attributes = new_attributes
        expect(feedback.ratings).to have(1).item
        
        rating = feedback.ratings.last
        expect(rating.value).to  eql 10
      end
      
      it 'rejects rating attributes if the value is absent' do
        new_attributes = {
          ratings_attributes: [{
            track_id: track.id,
            value:    nil
          }]
        }
        
        feedback.attributes = new_attributes
        expect(feedback.ratings).to be_empty
      end
    end
  end
  
  context 'instance methods' do
    describe '#rating_for' do
      let(:feedback) { create :feedback                         }
      let(:track)    { create :track, release: feedback.release }
      
      it 'returns an existing rating for the given track' do
        rating = create :rating, feedback: feedback, track: track
        expect(feedback.rating_for(track)).to eql rating
      end
      
      it "returns a new rating for the given track if it doesn't exist yet" do
        rating = feedback.rating_for(track)
        expect(rating).to be_a Rating
        expect(rating).to be_a_new_record
      end
    end
  end
end
