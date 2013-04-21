class Label < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :cover,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :releases
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
