class AddOwnerIdToLabels < ActiveRecord::Migration
  def up
    add_column :labels, :owner_id, :integer
    add_index  :labels, :owner_id
    
    Label.reset_column_information
    Label.update_all owner_id: User.first.id
    
    change_column :labels, :owner_id, :integer, null: false
  end
  
  def down
    remove_column :labels, :owner_id
  end
end
