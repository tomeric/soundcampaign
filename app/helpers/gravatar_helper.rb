require 'digest/md5'

module GravatarHelper
 def gravatar_tag(email, *args)
    opts = args.extract_options!
    
    opts[:class] ||= ""
    opts[:class]  += " gravatar"
    
    size = opts.delete(:size) || 80
    
    default = ""
    
    if opts[:default]
      require 'cgi'
      default= "&d=#{CGI::escape(opts.delete(:default))}"
    end
    
    hash = Digest::MD5.hexdigest(email.downcase)
    
    image_tag "http://www.gravatar.com/avatar/#{hash}?size=#{size}#{default}", opts
  end
end