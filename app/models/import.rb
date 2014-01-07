class Import < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :spreadsheet
  
  ### ASSOCIATIONS:
  
  belongs_to :context,
    polymorphic: true
  
  has_many :rows,
    -> { order :position },
    class_name: Import::Row,
    dependent:  :destroy
  
  ### VALIDATIONS:
  
  validates_attachment :spreadsheet,
    presence: true
  
  validate :valid_spreadsheet, if: :spreadsheet?
  
  ### CALLBACKS:
  
  after_create :import_rows!
  
  ### INSTANCE METHODS:
  
  def import_rows!
    save if changed?
    
    parseable_spreadsheet.each_with_index do |columns, position|
      import_row columns, position
    end
    
    rows
  end
  
  def import_row(columns, position)
    unless columns.all?(&:blank?)
      rows.create! columns: columns, position: position
    end
  end
  
  private
  
  def parseable_spreadsheet
    begin
      require 'roo'
      Roo::Spreadsheet.open(
        spreadsheet_io.path,
        csv_options: { encoding: spreadsheet_encoding }
      )
    rescue
      nil
    end
  end
  
  def spreadsheet_encoding
    begin
      require 'charlock_holmes'
      
      contents  = File.read spreadsheet_io.path
      detection = CharlockHolmes::EncodingDetector.detect contents
      detection.try(:[], :encoding) || 'UTF-8'
    rescue
      'UTF-8'
    end
  end
  
  def spreadsheet_io
    file = spreadsheet.queued_for_write[:original]
    file || Paperclip.io_adapters.for(spreadsheet)
  end
  
  def valid_spreadsheet
    if parseable_spreadsheet
      true
    else
      errors.add :spreadsheet, :invalid
      false
    end
  end
  
end
