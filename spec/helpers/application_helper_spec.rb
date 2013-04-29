require 'spec_helper'

describe ApplicationHelper do
  describe '#flash_messages' do
    before do
      helper.stub(:flash)
            .and_return(warning: "This is a warning.")
    end
    
    let(:flash_messages) { helper.flash_messages }
    
    it 'includes the message' do
      expect(flash_messages).to include '<p>This is a warning.</p>'
    end
    
    it 'returns nil if there are no messages' do
      helper.stub(:flash)
            .and_return({})
      
      expect(flash_messages).to be_nil
    end
  end
end
