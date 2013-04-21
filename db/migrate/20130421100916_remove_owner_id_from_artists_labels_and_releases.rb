class RemoveOwnerIdFromArtistsLabelsAndReleases < ActiveRecord::Migration
  def change
    remove_column :artists,  :owner_id
    remove_column :labels,   :owner_id
    remove_column :releases, :owner_id
  end
end
