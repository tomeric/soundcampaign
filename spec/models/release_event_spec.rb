require 'spec_helper'

describe ReleaseEvent do
  subject(:event) { build :release_event }
  
  it { should be_valid }
  
  context 'class methods' do
    describe '.for' do
      it 'raises an exception' do
        expect { ReleaseEvent.for(Object.new) }.to raise_error
      end
    end
  end
end
