class ContactList < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :contacts
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true,
    uniqueness: {
      scope: :organization_id
    }
  
  ### CALLBACKS:
  
  after_create :add_organization_members_as_contacts
  
  private
  
  def add_organization_members_as_contacts
    organization.members.find_each do |member|
      contacts.create! email: member.email, name: member.name
    end
  end
  
end
