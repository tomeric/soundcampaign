class AddAudioPropertiesToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :length,      :integer
    add_column :tracks, :bitrate,     :integer
    add_column :tracks, :sample_rate, :integer
    add_column :tracks, :channels,    :integer
    
    Track.find_each do |track|
      begin
        attachment = track.send(:attachment_io)
        TagLib::FileRef.open(attachment.path) do |fileref|
          properties = fileref.audio_properties
          track.update_attributes(
            length:      properties.length,
            bitrate:     properties.bitrate,
            sample_rate: properties.sample_rate,
            channels:    properties.channels
          )
        end
      rescue => e
        puts "Failed to get audio properties for track #{track.id}:\n#{e.inspect}"
      end
    end
  end
end
