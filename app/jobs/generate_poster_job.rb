class GeneratePosterJob < Struct.new(:cover_id)
  
  ### CLASS METHODS:
  
  def self.perform_later(cover)
    Delayed::Job.enqueue new(cover.id)
  end
  
  ### INSTANCE METHODS:
  
  def perform
    cover = Cover.find_by id: cover_id
    cover.try :generate_poster
  end
  
end
