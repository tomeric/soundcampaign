require 'spec_helper'

describe FeedbackEvent do
  subject(:event) { build :feedback_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on create' do
      let(:feedback) { event.parent }
      
      it "sets the event's created_at to the feedback's created_at" do
        Timecop.freeze do
          feedback.created_at = 3.days.ago
          
          expect {
            event.save
          }.to change {
            event.created_at
          }.to 3.days.ago
        end
      end
      
      it "sets the event's release to the feedback's release" do
        expect {
          event.save
        }.to change {
          event.release
        }.to feedback.release
      end
      
      it "sets the event's recipient to the feedback's recipient" do
        expect {
          event.save
        }.to change {
          event.recipient
        }.to feedback.recipient
      end
    end
  end
  
  context 'class methods' do
    describe '.for' do
      it 'creates a single FeedbackEvent for a feedback' do
        feedback = create :feedback
        
        expect {
          FeedbackEvent.for(feedback)
        }.to change {
          FeedbackEvent.count
        }.by +1
        
        expect {
          FeedbackEvent.for(feedback)
        }.to_not change {
          FeedbackEvent.count
        }
      end
    end
  end
end
