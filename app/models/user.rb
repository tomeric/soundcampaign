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
  
  ### CALLBACKS:
  
  before_create :create_default_organization,
    unless: :organization
  
  ### INSTANCE METHODS:
  
  def has_role?(name)
    roles.any? { |r| r.name == name }
  end
  
  private
  
  def create_default_organization
    self.organization = create_organization name: name
  end
  
end
