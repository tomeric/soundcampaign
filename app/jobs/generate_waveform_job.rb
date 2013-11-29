class GenerateWaveformJob < Struct.new(:track_id)
  
  ### CLASS METHODS:
  
  def self.perform_later(track)
    Delayed::Job.enqueue new(track.id)
  end
  
  ### INSTANCE METHODS:
  
  def perform
    track = Track.find_by id: track_id
    track.try :generate_waveform!
  end
  
end
