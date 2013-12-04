require 'spec_helper'

shared_examples_for Archivable do |options|
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
      
      if associations = options.try(:[], :associations)
        associations.each do |association, factory|
          let!(:associated_model) { factory.call(model) }
          
          it "sets deleted_at of associated #{association.to_s.singularize} to the current time" do
            Timecop.freeze do
              expect {
                model.archive
              }.to change {
                associated_model.reload.deleted_at
              }.to Time.now
            end
          end
          
          it "doesn't set deleted_at of previously archived #{association.to_s.singularize} to the current time" do
            Timecop.freeze do
              associated_model.archive(1.day.ago)
              
              expect {
                model.archive
              }.to_not change {
                associated_model.reload.deleted_at
              }
            end
          end
        end
      end
    end
    
    describe '#unarchive' do
      it 'sets deleted_at to nil' do
        model.archive
        expect {
          model.unarchive
        }.to change {
          model.deleted_at
        }.to nil
      end
      
      if associations = options.try(:[], :associations)
        associations.each do |association, factory|
          let!(:associated_model) { factory.call(model) }
          
          it "sets deleted_at of associated #{association.to_s.singularize} to nil" do
            model.archive
            
            expect {
              model.unarchive
            }.to change {
              associated_model.reload.deleted_at
            }.to nil
          end
          
          it "doesn't set deleted_at of previously archived #{association.to_s.singularize} to nil" do
            associated_model.archive(1.day.ago)
            model.archive
            
            expect {
              model.unarchive
            }.to_not change {
              associated_model.reload.deleted_at
            }
          end
        end
      end
    end
  end
end
