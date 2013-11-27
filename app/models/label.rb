class Label < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  has_one :cover,
    as: :coverable
  
  belongs_to :organization
  
  has_many :releases,
    dependent: :destroy
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  ### INSTANCE METHODS:
  
  def cover_id
    cover.try(:id)
  end
  
  def cover_id=(new_cover_id)
    self.cover = Cover.find_by id: new_cover_id
  end
  
end
