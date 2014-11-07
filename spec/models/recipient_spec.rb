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
  
  describe 'instance methods' do
    describe '#clicked_link?' do
      subject(:recipient) { create :recipient }
      
      it 'returns true if the recipient has any email log with clicked_at set' do
        create :email_log, recipient: recipient, clicked_at: Time.now
        expect(recipient.clicked_link?).to be true
      end
      
      it 'returns false if the recipient has no email log with clicked_at set' do
        create :email_log, recipient: recipient, clicked_at: nil
        expect(recipient.clicked_link?).to be false
      end
      
      it 'returns false if the recipient has no email logs' do
        expect(recipient.email_logs).to    be_empty
        expect(recipient.clicked_link?).to be false
      end
    end
  end
end
