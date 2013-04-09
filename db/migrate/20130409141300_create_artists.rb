class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.belongs_to :owner, null: false, index: true
      t.string     :name,  null: false
      t.text       :bio
      t.string     :soundcloud_url
      t.string     :facebook_url
      t.string     :twitter
      t.string     :beatport_url
      t.string     :website_url
      t.string     :email
      t.string     :country
    end
    
    add_attachment :artists, :cover
    
    add_column :artists, :created_at, :datetime
    add_column :artists, :updated_at, :datetime
  end
end
