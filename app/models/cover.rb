class Cover < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :poster
  
  has_attached_file :attachment,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :coverable,
    polymorphic: true
  
  ### CALLBACKS:
  
  after_save :generate_poster_later, if: :attachment_changed?
  
  ### INSTANCE METHODS:
  
  def url(style = :original)
    attachment.url(style)
  end
  
  def poster_url
    poster.url
  end
  
  def generate_poster_later
    GeneratePosterJob.perform_later(self)
  end
  
  def generate_poster(options = {})
    if attachment?
      generator   = PosterGenerator.new(attachment_io, options)
      self.poster = generator.create
      save!
    end
  end
  
  def attachment_changed?
    attachment.dirty?
  end
  
  private
  
  def attachment_io
    file = attachment.queued_for_write[:original]
    file || Paperclip.io_adapters.for(attachment)
  end
  
end
