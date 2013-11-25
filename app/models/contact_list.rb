class ContactList < ActiveRecord::Base
  include Archivable
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  has_many :contacts,
    dependent: :destroy
  
  ### VALIDATIONS:
  
  validates :name,
    presence: true,
    uniqueness: {
      scope: :organization_id
    }
  
  ### CALLBACKS:
  
  after_create :add_organization_members_as_contacts
  
  ### IMPORTING:
  
  has_many :imports, as: :context do
    def mappings
      {
        name:       -> contact, value, row { contact.name    = value                                       },
        email:      -> contact, value, row { contact.email   = value                                       },
        first_name: -> contact, value, row { contact.name  ||= [value,  row[:last_name]].compact.join(' ') },
        last_name:  -> contact, value, row { contact.name  ||= [row[:first_name], value].compact.join(' ') }
      }
    end
    
    def process(row)
      row  = row.symbolize_keys
      
      list = proxy_association.owner
      contact = list.contacts.new
      
      row.each do |key, value|
        mapping = mappings[key]
        if mapping
          mapping.call(contact, value, row)
        end
      end
      
      if list.contacts.where(email: contact.email).present?
        return :duplicate
      else
        contact.save!
        return :created
      end
      
    rescue
      return :error
    end
  end
  
  private
  
  def add_organization_members_as_contacts
    organization.members.find_each do |member|
      contacts.create! email: member.email, name: member.name
    end
  end
  
end
