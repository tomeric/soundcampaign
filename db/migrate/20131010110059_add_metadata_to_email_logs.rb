class AddMetadataToEmailLogs < ActiveRecord::Migration
  def change
    add_column :email_logs, :sent_at,        :datetime
    add_column :email_logs, :opened_at,      :datetime
    add_column :email_logs, :clicked_at,     :datetime
    add_column :email_logs, :bounced,        :boolean,  default: false
    add_column :email_logs, :marked_as_spam, :boolean,  default: false
    add_column :email_logs, :clicked_links,  :string,   default: [],    array: true
  end
end
