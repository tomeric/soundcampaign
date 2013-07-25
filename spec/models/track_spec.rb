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
    describe '#set_attachment_tags_from_track_attributes' do
      let(:track) {
        build :track,
          title:    'The Awesome Title',
          artist:   'The Awesome Artist',
          position: 3,
          release:  build(:release, title: 'The Awesome Album')
      }
      
      it "updates the attachment's id3 tags based on the track attributes" do
        track.set_attachment_tags_from_track_attributes
        
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
    
    describe '#set_track_attributes_from_attachment_tags' do
      let(:track) { build :track, attachment: fixture('track_id3.mp3') }
      
      it "sets the track's attributes based on information from the id3 tags" do
        track.title  = nil # Only set when nil
        track.artist = nil # Only set when nil
        track.set_track_attributes_from_attachment_tags
        
        expect(track.title).to       eql 'ID3 Title'
        expect(track.artist).to      eql 'ID3 Artist'
        expect(track.length).to      eql 5
        expect(track.bitrate).to     eql 48
        expect(track.channels).to    eql 1
        expect(track.sample_rate).to eql 44100
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
        
        it "sets the track's attributes from the attachment's tags" do
          expect(track).to receive(:set_track_attributes_from_attachment_tags)
          track.set_track_attributes
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
