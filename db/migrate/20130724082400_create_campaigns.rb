class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.belongs_to :release,   index: true
      t.string :name,          null: false
      t.string :email_subject, null: false
      t.string :email_from,    null: false
      t.text   :body
      t.timestamps
    end
  end
end
