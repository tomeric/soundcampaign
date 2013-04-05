if Rails.env.production?
  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:url] = '/system/:class/:attachment/:id_partition/:style/:filename'
end
