require 'spec_helper'

describe Recipient do
  subject(:recipient) { build :recipient }
  
  it { should be_valid }
  
  describe 'callbacks' do
    context 'on create' do
      it 'generates a unique secret' do
        recipient.secret = nil
        recipient.save
        expect(recipient.secret).to be_present
      end
    end
  end
end
