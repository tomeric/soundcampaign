class CreateReleaseArtists < ActiveRecord::Migration
  def change
    create_table :release_artists do |t|
      t.belongs_to :release, index: true, null: false
      t.belongs_to :artist,  index: true, null: false
      t.timestamps
    end
    
    add_index :release_artists, [:release_id, :artist_id], unique: true
  end
end
