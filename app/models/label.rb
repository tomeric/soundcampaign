class Label < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :cover,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  ### ASSOCIATIONS:
  
  belongs_to :owner,
    class_name: User
  
end
