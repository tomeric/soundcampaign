class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :users, :organization_id, :integer
    
    User.reset_column_information
    
    if 'organization_id'.in? User.column_names
      org = Organization.create name: 'Sound Campaign'
      User.update_all organization_id: org.id
      
      change_column :users, :organization_id, :integer, null: false
    end
  end
end
