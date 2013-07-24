require 'spec_helper'
require_relative './concerns/archivable'

describe Track do
  subject(:track) { build :track }
  
  it { should be_valid }
  
  it_behaves_like Archivable
  
  describe 'callbacks' do
    context 'on creation' do
      it "sets the track's attributes" do
        expect(track).to receive(:set_track_attributes)
        track.save
      end
    end
  end
  
  describe 'instance methods' do
    describe '#update_attachment_from_track_attributes' do
      it "updates the attachment's id3 tags based on the track attributes" do
        track.title    = 'The Awesome Title'
        track.artist   = 'The Awesome Artist'
        track.release  = build :release, title: 'The Awesome Album'
        track.position = 3
        track.update_attachment_from_track_attributes
        
        file = track.send(:attachment_io)
        
        TagLib::FileRef.open(file.path) do |file|
          tag = file.tag
          expect(tag.title).to  eql 'The Awesome Title'
          expect(tag.artist).to eql 'The Awesome Artist'
          expect(tag.album).to  eql 'The Awesome Album'
          expect(tag.track).to  eql 4
        end
      end 
    end
    
    describe '#set_track_attributes' do
      context 'without id3 tags' do
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
      end
      
      context 'with id3 tags' do
        let(:track) { build :track, attachment: fixture('track_id3.mp3') }
        
        it "sets the track's title to the title in the id3 tag" do
          track.title = nil
          
          expect {
            track.set_track_attributes
          }.to change {
            track.title
          }.to 'ID3 Title'
        end
        
        it "sets the track's artist to the artist in the id3 tag" do
          track.artist = nil
          
          expect {
            track.set_track_attributes
          }.to change {
            track.artist
          }.to 'ID3 Artist'
        end
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
