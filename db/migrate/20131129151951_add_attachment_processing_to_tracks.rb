class AddAttachmentProcessingToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :attachment_processing, :boolean
  end
end
