class AddInviteCodeToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :invite_code, :string
    
    Subscriber.reset_column_information
    Subscriber.find_each do |subscriber|
      subscriber.generate_invite_code
      subscriber.save
    end
    
    add_index :subscribers, :invite_code, unique: true
  end
end
