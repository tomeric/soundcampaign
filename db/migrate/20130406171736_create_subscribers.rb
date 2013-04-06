class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email, null: false
      t.timestamps
    end
    
    add_index :subscribers, :email, unique: true
  end
end
