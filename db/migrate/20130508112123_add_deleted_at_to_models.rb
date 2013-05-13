class AddDeletedAtToModels < ActiveRecord::Migration
  def up
    add_column :artists,       :deleted_at, :datetime
    add_column :contact_lists, :deleted_at, :datetime
    add_column :contacts,      :deleted_at, :datetime
    add_column :labels,        :deleted_at, :datetime
    add_column :releases,      :deleted_at, :datetime
    add_column :tracks,        :deleted_at, :datetime
    
    remove_index :contacts, [:email, :contact_list_id]
    add_index    :contacts, [:email, :contact_list_id, :deleted_at],
                            unique: true, name: 'contact_list_contact'
  end
  
  def down
    remove_index :contacts, name: 'contact_list_contact'
    
    remove_column :artists,       :deleted_at
    remove_column :contact_lists, :deleted_at
    remove_column :contacts,      :deleted_at
    remove_column :labels,        :deleted_at
    remove_column :releases,      :deleted_at
    remove_column :tracks,        :deleted_at
    
    add_index :contacts, [:email, :contact_list_id], unique: true
  end
end
