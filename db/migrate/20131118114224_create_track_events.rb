class CreateTrackEvents < ActiveRecord::Migration
  def change
    create_table :track_events do |t|
      t.belongs_to :track,        null: false
      t.string     :action,       null: false
      t.belongs_to :subscriber
      t.belongs_to :user
      t.text       :payload_json, default: '{}'
      t.timestamps
    end
  end
end
