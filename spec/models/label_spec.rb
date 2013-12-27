require 'spec_helper'
require_relative './concerns/archivable'

describe Label do
  subject(:label) { build :label }
  
  it { should be_valid }
  
  it_behaves_like Archivable,
    associations: {
      releases: -> label { FactoryGirl.create :release, label: label }
    }
  
  context 'instance methods' do
    describe '#cover_id' do
      it "returns the cover's id" do
        cover = create :cover
        label.cover = cover
        expect(label.cover_id).to eql cover.id
      end
      
      it 'returns nil if the cover is absent' do
        label.cover = nil
        expect(label.cover_id).to be_nil
      end
    end
    
    describe '#cover_id=' do
      it 'sets the cover to the Cover with the given id' do
        cover = create :cover
        label.cover_id = cover.id
        expect(label.cover).to eql cover
      end
      
      it 'sets the cover to nil if no Cover can be found with the given id' do
        cover = create :cover
        label.cover = cover
        label.cover_id = cover.id + 1_000
        expect(label.cover).to be_nil
      end
    end
  end
end
