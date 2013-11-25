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
  
end
