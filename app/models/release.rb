class Release < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :cover,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  belongs_to :owner,
    class_name: User
  
  belongs_to :label
  
  has_many :tracks
  accepts_nested_attributes_for :tracks
  
  has_many :release_artists
  
  has_many :artists,
    through: :release_artists
  
  ### VALIDATIONS:
  
  validates :title,
    presence: true
  
  ### INSTANCE METHODS:
  
  def owners
    owner.organization.members
  end
end
