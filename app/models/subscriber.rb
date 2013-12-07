require 'digest/md5'

class Subscriber < ActiveRecord::Base
  
  ### VALIDATIONS:
  
  validates :email,
    presence:   true,
    email:      true,
    uniqueness: true
  
  validates :invite_code,
    presence:   true,
    uniqueness: true
  
  ### CALLBACKS:
  
  before_validation :generate_invite_code,
    on:     :create,
    unless: :invite_code?
  
  ### INSTANCE METHODS:
  
  def invite_used?
    !!(invite_code? && User.where(invite_code: invite_code).exists?)
  end
  
  def generate_invite_code
    seeds  = []
    seeds << email
    seeds << rand(1000_000)
    seeds << Time.now.to_i
    
    seed = seeds.compact.join '+'
    
    self.invite_code = Digest::MD5.hexdigest(seed)
  end
  
end
