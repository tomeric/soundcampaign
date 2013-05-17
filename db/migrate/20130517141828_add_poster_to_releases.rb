class AddPosterToReleases < ActiveRecord::Migration
  def change
    add_attachment :releases, :poster
  end
end
