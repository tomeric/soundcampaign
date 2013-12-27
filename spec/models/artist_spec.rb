require 'spec_helper'
require_relative './concerns/archivable'

describe Artist do
  subject(:artist) { build :artist }
  
  it { should be_valid }
  
  it_behaves_like Archivable
  
  context 'instance methods' do
    describe '#cover_id' do
      it "returns the cover's id" do
        cover = create :cover
        artist.cover = cover
        expect(artist.cover_id).to eql cover.id
      end
      
      it 'returns nil if the cover is absent' do
        artist.cover = nil
        expect(artist.cover_id).to be_nil
      end
    end
    
    describe '#cover_id=' do
      it 'sets the cover to the Cover with the given id' do
        cover = create :cover
        artist.cover_id = cover.id
        expect(artist.cover).to eql cover
      end
      
      it 'sets the cover to nil if no Cover can be found with the given id' do
        cover = create :cover
        artist.cover = cover
        artist.cover_id = cover.id + 1_000
        expect(artist.cover).to be_nil
      end
    end
  end
end
