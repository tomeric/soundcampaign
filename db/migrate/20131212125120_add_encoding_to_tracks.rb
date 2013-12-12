class AddEncodingToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :encoding, :boolean, default: nil
  end
end
