require 'spec_helper'

describe Cover do
  subject(:cover) { build :cover }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on save' do
      let!(:cover) { create :cover }
      
      it "doesn't perform a GeneratePosterJob later if the attachment stays the same" do
        GeneratePosterJob.should_not_receive(:perform_later)
        
        cover.save
      end
      
      it 'performs a GeneratePosterJob later if the cover changes' do
        GeneratePosterJob.should_receive(:perform_later)
                         .with(cover)
        
        cover.attachment = fixture 'cover_2.jpg'
        cover.save
      end
    end
  end
end
