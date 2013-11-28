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
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
end
