class Organization < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  has_many :members,
    class_name: User
  
  has_many :artists,
    dependent: :destroy
  
  has_many :contact_lists,
    dependent: :destroy
  
  has_many :contacts,
    through: :contact_lists
  
  has_many :labels,
    dependent: :destroy
  
  has_many :releases,
    dependent: :destroy
  
  has_many :tracks
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true
  
  ### INSTANCE METHODS:
  
  def used_disk_space
    tracks.sum(:attachment_file_size)
  end
  
  def available_disk_space
    1.gigabyte
  end
  
  def used_bandwidth
    0.bytes
  end
  
  def available_bandwidth
    1.gigabyte
  end
  
end
