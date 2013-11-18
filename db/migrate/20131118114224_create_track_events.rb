class CreateTrackEvents < ActiveRecord::Migration
  def change
    create_table :track_events do |t|
      t.belongs_to :track,      null: false
      t.string     :action,     null: false
      t.belongs_to :subscriber
      t.belongs_to :user
      t.json       :payload
      t.timestamps
    end
  end
end
