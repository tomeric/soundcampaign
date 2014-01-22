require 'spec_helper'

describe TrackPlayEvent do
  subject(:event) { build :track_play_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on create' do
      let(:track_event) { event.parent }
      
      it "sets the event's created_at to the track event's created_at" do
        Timecop.freeze do
          track_event.created_at = 3.days.ago
          expect {
            event.save
          }.to change {
            event.created_at
          }.to 3.days.ago
        end
      end
      
      it "sets the event's release to the track event's track's release" do
        expect {
          event.save
        }.to change {
          event.release
        }.to track_event.track.release
      end
      
      it "sets the event's recipient to the track event's recipient" do
        expect {
          event.save
        }.to change {
          event.recipient
        }.to track_event.recipient
      end
    end
  end
  
  context 'class methods' do
    describe '.for' do
      it 'creates a single TrackPlayEvent for a "play" TrackEvent' do
        track_event = create :played_track_event
        
        expect {
          TrackPlayEvent.for(track_event)
        }.to change {
          TrackPlayEvent.count
        }.by +1
        
        expect {
          TrackPlayEvent.for(track_event)
        }.to_not change {
          TrackPlayEvent.count
        }
      end
      
      it "doesn't create a TrackPlayEvent for a TrackEvent that is not 'play'" do
        track_event = create :paused_track_event
        
        expect {
          TrackPlayEvent.for(track_event)
        }.to_not change {
          TrackPlayEvent.count
        }
      end
    end
  end
end
