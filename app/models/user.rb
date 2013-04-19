class User < ActiveRecord::Base
  
  ### DEVISE:
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :labels,
    foreign_key: 'owner_id'
  
  has_many :artists,
    foreign_key: 'owner_id'
  
  has_many :releases,
    foreign_key: 'owner_id'
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
