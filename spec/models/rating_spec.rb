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
end
