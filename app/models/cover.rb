class Cover < ActiveRecord::Base
  
  ### PAPERCLIP:
  
  has_attached_file :poster
  
  has_attached_file :attachment,
    styles: {
      thumbnail:    ['230x460', :jpg],
      thumbnail_2x: ['460x460', :jpg]
    }
  
  ### ASSOCIATIONS:
  
  belongs_to :organization
  
  belongs_to :coverable,
    polymorphic: true
  
  ### CALLBACKS:
  
  after_save :generate_poster_later
  
  ### INSTANCE METHODS:
  
  def as_json(options = {})
    super.delete_if do |key, value|
      key =~ %r{^(attachment|poster|coverable)_}
    end.merge(
      attachment:    url(:thumbnail),
      attachment_2x: url(:thumbnail_2x),
      poster:        poster_url
    ).merge(
      "#{coverable_type.underscore.to_sym}_id" => coverable_id
    )
  end
  
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
  
  private
  
  def attachment_io
    file = attachment.queued_for_write[:original]
    file || Paperclip.io_adapters.for(attachment)
  end
  
end
