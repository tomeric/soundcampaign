require 'spec_helper'

describe EmailLog do
  subject(:email) { build :email_log }
  
  it { should be_valid }
  
  describe 'callbacks' do
    context 'on save' do
      it 'connects to a campaign' do
        email.should_receive(:connect_to_campaign)
        email.save
      end
    end
  end
  
  context 'instance methods' do
    describe '#connect_to_campaign' do
      def generate_message_id(campaign_id = rand(1000_000))
        "campaign:#{campaign_id}+#{SecureRandom.uuid}"
      end
      
      it 'connects to the campaign from the message_id' do
        campaign = create :campaign
        email.message_id = generate_message_id campaign.id
        email.connect_to_campaign
        expect(email.campaign).to eql campaign
      end
      
      it "doesn't connect to non-existing campaigns" do
        email.message_id = generate_message_id
        email.connect_to_campaign
        expect(email.campaign).to be_nil
      end
      
      it "doesn't connect if the message_id doesn't contain a campaign id" do
        email.message_id = "abcdefghijklmnopqrstuvwxy"
        email.connect_to_campaign
        expect(email.campaign).to be_nil
      end
    end
  end
end
