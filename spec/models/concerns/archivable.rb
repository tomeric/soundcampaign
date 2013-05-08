require 'spec_helper'

shared_examples_for Archivable do
  let!(:klass) { subject.class }
  let(:model) do
    subject.save! if subject.new_record?
    subject
  end
  
  context 'scopes' do
    let(:archived) do
      model.update_column :deleted_at, Time.now
      model
    end
    
    let(:unarchived) do
      model.update_column :deleted_at, nil
      model
    end
    
    describe '.archived' do
      it 'includes archived objects' do
        expect(archived).to be_in klass.archived
      end
      
      it 'excludes unarchived objects' do
        expect(unarchived).to_not be_in klass.archived
      end
    end
    
    describe '.unarchived' do
      it 'excludes archived objects' do
        expect(archived).to_not be_in klass.unarchived
      end
      
      it 'includes unarchived objects' do
        expect(unarchived).to be_in klass.unarchived
      end
    end
    
    describe 'default scope' do
      it 'excludes archived objects' do
        expect(archived).to_not be_in klass.all
      end
      
      it 'includes unarchived objects' do
        expect(unarchived).to be_in klass.all
      end
    end
  end
  
  context 'instance methods' do
    describe '#archive' do
      it 'sets deleted_at to the current time' do
        Timecop.freeze do
          expect {
            model.archive
          }.to change {
            model.deleted_at
          }.to Time.now
        end
      end
    end
  end
end
