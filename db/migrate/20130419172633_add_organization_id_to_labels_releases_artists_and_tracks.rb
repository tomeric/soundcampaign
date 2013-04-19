class AddOrganizationIdToLabelsReleasesArtistsAndTracks < ActiveRecord::Migration
  def change
    add_column :labels,   :organization_id, :integer
    add_column :releases, :organization_id, :integer
    add_column :artists,  :organization_id, :integer
    add_column :tracks,   :organization_id, :integer
    
    models = [Label, Release, Artist, Track]
    models.each(&:reset_column_information)
    
    if models.all? { |m| 'organization_id'.in? m.column_names }
      models.each do |model_class|
        model_class.find_each do |object|
          if object.respond_to? :owner
            object.update_column :organization_id, object.owner.organization_id
          else
            object.update_column :organization_id, Organization.first.id
          end
        end
      end
      
      change_column :labels,   :organization_id, :integer, null: false
      change_column :releases, :organization_id, :integer, null: false
      change_column :artists,  :organization_id, :integer, null: false
      change_column :tracks,   :organization_id, :integer, null: false
    end
  end
end
