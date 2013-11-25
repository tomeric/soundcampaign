class CreateCovers < ActiveRecord::Migration
  def up
    create_table :covers do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :coverable,    index: true, polymorphic: true
      t.attachment :attachment
      t.attachment :poster
      t.timestamps
    end
    
    Cover.reset_column_information
    
    Release.class_eval do
      has_attached_file :cover,
        styles: {
          thumbnail:    ['230x460', :jpg],
          thumbnail_2x: ['460x460', :jpg]
        }
    end
    Release.find_each do |release|
      begin
        Cover.create coverable: release, attachment: release.cover
      rescue => e
        puts e.inspect
      end if release.cover?
    end
    
    Label.class_eval do
      has_attached_file :cover,
        styles: {
          thumbnail:    ['230x460', :jpg],
          thumbnail_2x: ['460x460', :jpg]
        }
    end
    Label.find_each do |label|
      begin
        Cover.create coverable: label, attachment: label.cover
      rescue => e
        puts e.inspect
      end if label.cover?
    end
    
    Artist.class_eval do
      has_attached_file :cover,
        styles: {
          thumbnail:    ['230x460', :jpg],
          thumbnail_2x: ['460x460', :jpg]
        }
    end
    Artist.find_each do |artist|
      begin
        Cover.create coverable: artist, attachment: artist.cover
      rescue => e
        puts e.inspect
      end if artist.cover?
    end
    
    columns = %w[cover_file_name cover_content_type cover_file_size cover_updated_at]
    tables  = %w[releases labels artists]
    
    tables.each do |table|
      columns.each do |column|
        remove_column table, column
      end
    end
  end
  
  def down
    add_column :releases, :cover,   :attachment
    add_column :releases, :labels,  :attachment
    add_column :releases, :artists, :attachment
    drop_table :covers
  end
end
