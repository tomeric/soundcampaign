class ReleaseEvent < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :release
  
  belongs_to :recipient
  
  ### CLASS METHODS:
  
  def self.for(object)
    raise 'Implement this method in your subclass.'
  end
  
end
