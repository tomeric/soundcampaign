class ChangeContactsFirstAndLastNameToName < ActiveRecord::Migration
  def change
    add_column :contacts, :name, :string
    
    Contact.reset_column_information
    if %w(first_name last_name name).all? { |column| column.in? Contact.column_names }
      Contact.find_each do |contact|
        contact.update_column :name, "#{contact.first_name} #{contact.last_name}".strip
      end
    end
    
    remove_column :contacts, :first_name
    remove_column :contacts, :last_name
  end
end
