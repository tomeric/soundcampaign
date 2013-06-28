require 'spec_helper'

describe Organization do
  subject(:organization) { build :organization }
  
  it { should be_valid }
  
  context 'instance methods' do
    describe '#used_disk_space' do
      let(:organization) { create :organization }
      
      it "returns the summed size of the organization's tracks" do
        release = create :release, organization: organization
        tracks  = []
        
        3.times { tracks << create(:track, release: release, organization: organization) }
        summed_tracks_size = tracks.map(&:attachment_file_size).inject(0, &:+)
        
        expect(organization.used_disk_space).to eql summed_tracks_size
      end
    end
    
    describe '#available_disk_space' do
      it 'returns 1 gigabyte' do
        expect(organization.available_disk_space).to eql 1.gigabyte
      end
    end
    
    describe '#used_bandwidth' do
      it 'returns 0 bytes' do
        expect(organization.used_bandwidth).to eql 0.bytes
      end
    end
    
    describe '#available_bandwidth' do
      it 'returns 1 gigabyte' do
        expect(organization.available_bandwidth).to eql 1.gigabyte
      end
    end
  end
end
