class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.belongs_to :release, index: true
      t.integer :position
      t.string :artist
      t.string :title
    end
    
    add_attachment :tracks, :attachment
    
    add_column :tracks, :created_at, :datetime
    add_column :tracks, :updated_at, :datetime
  end
end
