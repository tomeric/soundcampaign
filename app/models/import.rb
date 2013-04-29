require 'roo'

class Import < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :spreadsheet
  
  ### ASSOCIATIONS:
  
  belongs_to :context,
    polymorphic: true
  
  has_many :rows,
    class_name: Import::Row
  
  ### VALIDATIONS:
  
  validates_attachment :spreadsheet,
    presence: true
  
  ### INSTANCE METHODS:
  
  def import_rows!
    save if changed?
    
    file  = Paperclip.io_adapters.for(spreadsheet)
    sheet = Roo::Spreadsheet.open(file.path)
    
    sheet.each_with_index do |columns, position|
      unless columns.all?(&:blank?)
        rows.create! columns: columns, position: position
      end
    end
    
    rows
  end
  
end
