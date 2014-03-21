class ReleaseEvent < ActiveRecord::Base
  
  PREVIOUS_SIBLING_INTERVAL = 5.minutes
  
  ### ASSOCIATIONS:
  
  has_many :upcoming_siblings,
    -> {
      order(created_at: :asc)
    },
    class_name:  ReleaseEvent,
    foreign_key: 'first_sibling_id'
  
  belongs_to :first_sibling,
    class_name:  ReleaseEvent
  
  belongs_to :release
  
  belongs_to :recipient
  
  ### CALLBACKS:
  
  after_create :connect_to_siblings
  
  ### SCOPES:
  
  scope :without_previous_siblings, -> {
    where(first_sibling_id: nil)
  }
  
  ### CLASS METHODS:
  
  def self.for(object)
    raise 'Implement this method in your subclass.'
  end
  
  ### INSTANCE METHODS:
  
  def connect_to_siblings
    # last_sibling = siblings.where(
    #   'created_at >= :start AND id <> :id',
    #   start: (created_at - PREVIOUS_SIBLING_INTERVAL).utc,
    #   id:    id
    # ).first
    # 
    # if last_sibling.present?
    #   first_sibling = last_sibling.first_sibling || last_sibling
    #   update_attributes first_sibling: first_sibling
    #   first_sibling.update_attributes upcoming_siblings_count: first_sibling.upcoming_siblings.count
    # end
  end
  
  def siblings
    self.class.unscoped.where(
      type:         self.class.to_s,
      release_id:   release_id,
      recipient_id: recipient_id
    ).order(created_at: :desc)
  end
  
end
