class AddEmailLogAssociationToMandrillEvents < ActiveRecord::Migration
  def change
    add_column :mandrill_events, :email_log_id, :integer
    add_index  :mandrill_events, :email_log_id
    
    MandrillEvent.reset_column_information
    MandrillEvent.find_each do |event|
      event.connect_to_email_log
      event.save
    end
  end
end
