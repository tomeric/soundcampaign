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
      
      it 'connects to a recipient' do
        email.should_receive(:connect_to_recipient)
        email.save
      end
      
      it 'tries to create a CampaignOpenEvent in the background' do
        expect(CampaignOpenEvent).to receive(:delay).and_return(CampaignOpenEvent)
        expect(CampaignOpenEvent).to receive(:for).with(kind_of(Integer))
        email.save
      end
    end
  end
  
  context 'instance methods' do
    def generate_message_id(campaign_id = rand(1000_000))
      "campaign:#{campaign_id}+#{SecureRandom.uuid}"
    end
    
    describe '#connect_to_campaign' do
      
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
    
    describe '#connect_to_recipient' do
      let(:campaign) { create :campaign }
      let(:email)    { build :email_log, message_id: generate_message_id(campaign.id) }
      
      it 'connects to the recipient of the campaign with the matching email address' do
        recipient = create :recipient, campaign: campaign, email: email.to[0]
        email.campaign = campaign
        email.connect_to_recipient
        expect(email.recipient).to eql recipient
      end
      
      it "doesn't connect to a recipient if it's not connected to a campaign" do
        recipient = create :recipient, email: email.to[0]
        email.connect_to_recipient
        expect(email.recipient).to be_nil
      end
      
      it "doesn't connect to other recipients of the campaign if the email address doesn't match" do
        recipient = create :recipient, campaign: campaign
        email.campaign = campaign
        email.connect_to_recipient
        expect(email.recipient).to be_nil
      end
    end
  end
end
