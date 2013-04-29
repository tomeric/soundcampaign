require 'spec_helper'

describe Import do
  subject(:import) { build :import }
  
  it { should be_valid }
  
  context 'instance methods' do
    describe '#import_rows!' do
      let(:import) { create :import }
      
      before do
        import.spreadsheet = fixture 'contacts.csv'
      end
      
      it 'imports the rows in the attached spreadsheet' do
        expect {
          import.import_rows!
        }.to change {
          import.rows.count
        }.by +4
      end
      
      it 'imports the columns of the rows in the attached spreadsheet' do
        rows = import.import_rows!
        row  = rows.first
        
        expect(row.columns).to eql ['email', 'name']
      end
    end
  end
end
