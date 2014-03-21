require 'spec_helper'

describe TrackEvent do
  subject(:event) { build :track_event }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on save' do
      it 'tries to create a TrackPlayEvent in the background' do
        expect(TrackPlayEvent).to receive(:delay).and_return(TrackPlayEvent)
        expect(TrackPlayEvent).to receive(:for).with(kind_of(Integer))
        event.save
      end
    end
  end
end
