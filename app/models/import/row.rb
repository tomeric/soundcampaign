class Import::Row < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :import
  
  ### CALLBACKS:
  
  before_save :normalize_columns
  
  private
  
  def normalize_columns
    self.columns = columns.map(&:presence)
  end
  
end