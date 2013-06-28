class Rating < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :feedback
  
  belongs_to :track
  
  ### VALIDATIONS:
  
  validates_numericality_of :value,
    less_than_or_equal_to:    10,
    greater_than_or_equal_to:  1,
    only_integer:             true
  
end
