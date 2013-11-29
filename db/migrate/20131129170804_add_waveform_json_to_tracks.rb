class AddWaveformJsonToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :waveform_json, :text
  end
end
