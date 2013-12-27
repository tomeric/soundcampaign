require 'spec_helper'

describe ApplicationHelper do
  describe '#page_title' do
    it 'includes the title at the start' do
      helper.title 'Page Title'
      expect(helper.page_title).to start_with 'Page Title — '
    end
    
    it 'strips HTML tags from the title' do
      helper.title '<a>Page</a> Title'
      expect(helper.page_title).to match /^Page Title — /
    end
    
    it 'includes the site_name at the end' do
      helper.stub(:site_name).and_return('Site Name')
      helper.title 'Page Title'
      expect(helper.page_title).to end_with 'Site Name'
    end
    
    it 'returns the site_name and the site_subtitle if no page_title is set' do
      helper.stub(:site_name).and_return('Site Name')
      helper.stub(:site_subtitle).and_return('Site Subtitle')
      expect(helper.page_title).to eql 'Site Name — Site Subtitle'
    end
  end
  
  describe '#site_name' do
    it 'returns the configured name' do
      Settings.stub(:[]).with('name').and_return('Site Name')
      expect(helper.site_name).to eql 'Site Name'
    end
  end
  
  describe '#site_subtitle' do
    it 'returns the configured subtitle' do
      Settings.stub(:[]).with('subtitle').and_return('Site Subtitle')
      expect(helper.site_subtitle).to eql 'Site Subtitle'
    end
  end
  
  describe '#title' do
    it 'stores the title and return it back' do
      helper.title 'Test title'
      expect(helper.title).to eql 'Test title'
    end
    
    it 'returns an empty string if no title is set' do
      expect(helper.title).to eql ''
    end
  end
  
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
