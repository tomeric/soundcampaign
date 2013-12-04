class User < ActiveRecord::Base
  
  ### DEVISE:
  
  devise *%i[ database_authenticatable
              recoverable
              registerable
              rememberable
              trackable
              validatable ]
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :roles
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  ### INSTANCE METHODS:
  
  def has_role?(name)
    roles.any? { |r| r.name == name }
  end
  
end
