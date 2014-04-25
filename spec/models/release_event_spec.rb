require 'spec_helper'

describe ReleaseEvent do
  subject(:event) { build :release_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    describe 'after create' do
      it 'connects to similar events made within the last 5 minutes' do
        release   = create :release
        recipient = create :recipient
        
        to_old   = create :release_event, release: release, recipient: recipient, created_at: 20.minutes.ago
        oldest   = create :release_event, release: release, recipient: recipient, created_at: 13.minutes.ago
        middle   = create :release_event, release: release, recipient: recipient, created_at: 12.minutes.ago
        youngest = create :release_event, release: release, recipient: recipient, created_at: 11.minute.ago
        
        expect(middle.first_sibling).to   eql oldest
        expect(youngest.first_sibling).to eql oldest
        
        expect(to_old.upcoming_siblings).to be_empty
        expect(oldest.upcoming_siblings.to_a).to eql [middle, youngest]
      end
      
      it "doesn't connect events that are not similar" do
        release   = create :release
        recipient = create :recipient
        
        oldest   = create :release_event, release: release,                       created_at: 13.minutes.ago
        middle   = create :release_event, release: release, recipient: recipient, created_at: 12.minutes.ago
        youngest = create :release_event,                   recipient: recipient, created_at: 11.minute.ago
        
        expect(oldest.first_sibling).to   be_blank
        expect(middle.first_sibling).to   be_blank
        expect(youngest.first_sibling).to be_blank
        
        expect(oldest.upcoming_siblings).to   be_empty
        expect(middle.upcoming_siblings).to   be_empty
        expect(youngest.upcoming_siblings).to be_empty
      end
      
      it "doesn't connect events that are a different type" do
        release   = create :release
        recipient = create :recipient
        
        oldest   = create :campaign_open_event, release: release, recipient: recipient, created_at: 13.minutes.ago
        middle   = create :feedback_event,      release: release, recipient: recipient, created_at: 12.minutes.ago
        youngest = create :track_play_event,    release: release, recipient: recipient, created_at: 11.minute.ago
        
        expect(oldest.first_sibling).to   be_blank
        expect(middle.first_sibling).to   be_blank
        expect(youngest.first_sibling).to be_blank
        
        expect(oldest.upcoming_siblings).to   be_empty
        expect(middle.upcoming_siblings).to   be_empty
        expect(youngest.upcoming_siblings).to be_empty
      end
    end
  end
  
  context 'class methods' do
    describe '.for' do
      it 'raises an exception' do
        expect { ReleaseEvent.for(Object.new) }.to raise_error
      end
    end
  end
end
