require 'spec_helper'

describe Import do
  subject(:import) { build :import }
  
  it { should be_valid }
  
  context 'validations' do
    it 'validates that the attached spreadsheet is a valid spreadsheet' do
      import.spreadsheet = fixture 'contacts.csv'
      expect(import).to be_valid
      
      import.spreadsheet = fixture 'cover.jpg'
      expect(import).to_not be_valid
      expect(import.errors[:spreadsheet]).to be_present
    end
  end
  
  context 'callbacks' do
    context 'after create' do
      it 'imports the spreadsheet rows' do
        expect(import).to receive(:import_rows!)
        import.save
      end
    end
  end
  
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
      
      context 'encodings and file formats' do
        Dir[Rails.root.join('spec','fixtures','import','*.*')].each do |import_path|
          basename = File.basename import_path
          
          before do
            fixture_path = import_path.gsub("#{Rails.root.join('spec', 'fixtures')}/", '')
            import.spreadsheet = fixture fixture_path
          end
          
          it "can import #{basename}" do
            expect {
              import.import_rows!
            }.to change {
              import.rows.count
            }
          end
        end
      end
    end
  end
end
