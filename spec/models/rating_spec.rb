require 'spec_helper'

describe Rating do
  subject(:rating) { build :rating }
  
  it { should be_valid }
  
  context 'validations' do
    it { should validate_numericality_of(:value) }
    it { should allow_value( 1).for(:value)      }
    it { should allow_value(10).for(:value)      }
    it { should_not allow_value(0).for(:value)   }
    it { should_not allow_value(11).for(:value)  }
  end

  context 'scopes' do
    describe '.for' do
      let(:track)        { create :track                }
      let(:track_rating) { create :rating, track: track }
      let(:other_rating) { create :rating               }

      it 'includes ratings for the given track' do
        expect(track_rating).to be_in Rating.for(track)
      end

      it 'excludes ratings for other tracks' do
        expect(other_rating).to_not be_in Rating.for(track)
      end
    end
  end
end
