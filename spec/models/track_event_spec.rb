require 'spec_helper'

describe TrackEvent do
  subject(:event) { build :track_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on save' do
      it 'tries to create a TrackPlayEvent' do
        expect(TrackPlayEvent).to receive(:for).with(event)
        event.save
      end
    end
  end
end
