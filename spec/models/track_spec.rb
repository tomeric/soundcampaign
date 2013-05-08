require 'spec_helper'
require_relative './concerns/archivable'

describe Track do
  subject(:track) { build :track }
  
  it { should be_valid }
  
  it_behaves_like Archivable
  
  describe 'callbacks' do
    context 'on creation' do
      it "sets the track's attributes" do
        track.should_receive(:set_track_attributes)
        track.save
      end
    end
  end
  
  describe 'instance methods' do
    describe '#set_track_attributes' do
      it "sets the track's title to 'Unknown Title'" do
        track.title = nil
        
        expect {
          track.set_track_attributes
        }.to change {
          track.title
        }.to 'Unknown Title'
      end
      
      it "sets the track's artist to 'Unknown Artist'" do
        track.artist = nil
        
        expect {
          track.set_track_attributes
        }.to change {
          track.artist
        }.to 'Unknown Artist'
      end
      
      it "doesn't overwrite attributes" do
        track.title = 'The Title'
        track.artist = 'The Artist'
        track.set_track_attributes
        expect(track.title).to  eq 'The Title'
        expect(track.artist).to eq 'The Artist'
      end
    end
  end
end
