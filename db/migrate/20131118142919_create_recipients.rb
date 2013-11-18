require 'digest/md5'

class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.belongs_to :campaign, index: true
      t.belongs_to :user,     index: true
      t.belongs_to :contact,  index: true
      t.string     :email,    null: false, unique: true
      t.string     :secret,   null: false, unique: true
      t.timestamps
    end
    
    # Change EmailLog's:
    add_column :email_logs, :recipient_id, :integer
    EmailLog.find_each do |log|
      log.to.each do |email|
        if campaign = log.campaign
          release   = campaign.release
          
          recipient = Recipient.where(campaign_id: campaign.id, email: email).first_or_initialize
          recipient.secret ||= Digest::MD5.hexdigest([Time.now, rand(1000_000_000)].join('+'))
          recipient.user     = User.find_by email: email
          recipient.contact  = release.organization.contacts.find_by email: email
          recipient.save
          
          if recipient.persisted?
            log.recipient = recipient
            log.save
          end
        end
      end
    end
    
    # Change TrackEvent's:
    add_column    :track_events, :recipient_id, :integer, null: false
    remove_column :track_events, :subscriber_id
    remove_column :track_events, :user_id
    TrackEvent.delete_all
  end
end
