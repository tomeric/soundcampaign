class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :contact_list, index: true
      t.string :email
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
    
    add_index :contacts, [:email, :contact_list_id], unique: true
    add_index :contacts, [:first_name, :last_name],  name: 'contact_name'
  end
end
