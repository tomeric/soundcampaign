require 'spec_helper'

describe Recipient do
  subject(:recipient) { build :recipient }
  
  it { should be_valid }
  
  describe 'callbacks' do
    context 'on create' do
      it 'generates a unique secret' do
        recipient.secret = nil
        recipient.save
        expect(recipient.secret).to be_present
      end
    end
  end
  
  describe 'instance methods' do
    describe '#clicked_link?' do
      subject(:recipient) { create :recipient }
      
      it 'returns true if the recipient has any email log with clicked_at set' do
        email_log = build :email_log, clicked_at: Time.now
        recipient.stub(:email_logs)
                 .and_return [email_log]
        
        expect(recipient.clicked_link?).to be true
      end
      
      it 'returns true if the recipient has a TrackPlay release event' do
        event = build :track_play_event
        recipient.stub(:release_events)
                 .and_return [event]
        
        expect(recipient.clicked_link?).to be true
      end
      
      it 'returns true if the recipient has a Feedback release event' do
        event = build :feedback_event
        recipient.stub(:release_events)
                 .and_return [event]
        
        expect(recipient.clicked_link?).to be true
      end
      
      it 'returns false if the recipient has no email log with clicked_at set' do
        email_log = build :email_log, clicked_at: nil
        recipient.stub(:email_logs)
                 .and_return [email_log]
        
        expect(recipient.clicked_link?).to be false
      end
      
      it 'returns false if the recipient has no email logs' do
        recipient.stub(:email_logs)
                 .and_return []
        
        expect(recipient.clicked_link?).to be false
      end
    end
  end
end
