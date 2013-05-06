require 'roo'

class Import < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :spreadsheet
  
  ### ASSOCIATIONS:
  
  belongs_to :context,
    polymorphic: true
  
  has_many :rows,
    class_name: Import::Row,
    order:      :position
  
  ### VALIDATIONS:
  
  validates_attachment :spreadsheet,
    presence: true
  
  validate :valid_spreadsheet, if: :spreadsheet?
  
  ### CALLBACKS:
  
  after_create :import_rows!
  
  ### INSTANCE METHODS:
  
  def import_rows!
    save if changed?
    
    sheet = Roo::Spreadsheet.open(attachment.path)
    sheet.each_with_index do |columns, position|
      unless columns.all?(&:blank?)
        rows.create! columns: columns, position: position
      end
    end
    
    rows
  end
  
  private
  
  def attachment
    file = spreadsheet.queued_for_write[:original]
    file || Paperclip.io_adapters.for(spreadsheet)
  end
  
  def valid_spreadsheet
    begin
      Roo::Spreadsheet.open(attachment.path)
      true
    rescue
      errors.add :spreadsheet, :invalid
      false
    end
  end
  
end
