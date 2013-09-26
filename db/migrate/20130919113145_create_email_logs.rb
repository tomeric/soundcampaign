class CreateEmailLogs < ActiveRecord::Migration
  def change
    create_table :email_logs do |t|
      t.string     :message_id
      t.belongs_to :campaign
      t.string     :to, array: true, default: []
      t.string     :from
      t.string     :subject
      t.text       :body
      t.timestamps
    end
    
    add_index :email_logs, :message_id, unique: true
    add_index :email_logs, :campaign_id
    add_index :email_logs, :to
  end
end
