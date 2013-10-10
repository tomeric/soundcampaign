class CreateMandrillEvents < ActiveRecord::Migration
  def change
    create_table :mandrill_events do |t|
      t.text :json_payload
      t.timestamps
    end
  end
end
