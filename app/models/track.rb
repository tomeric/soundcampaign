class Track < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :attachment
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  ### VALIDATIONS:
  
  validates :title,
    presence: true
  
  validates :artist,
    presence: true
  
end
