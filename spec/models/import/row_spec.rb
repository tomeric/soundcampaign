require 'spec_helper'

describe Import::Row do
  subject(:row) { build :import_row }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on save' do
      it 'normalizes columns so empty strings are persisted' do
        columns = ['A', nil, 'B', '', nil, 'C']
        row = create :import_row, columns: columns
        
        row = Import::Row.last
        expect(row.columns).to eql columns.map(&:presence)
      end
    end
  end
end
