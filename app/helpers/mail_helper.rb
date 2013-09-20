module MailHelper
  def simple_mail_format(text, html_options = {}, options = {})
    wrapper_tag = options[:wrapper_tag] || 'p'
    
    html = simple_format(text, html_options, options)
    html.gsub("<#{wrapper_tag}>",  '')
        .gsub("</#{wrapper_tag}>", '<br><br>')
        .html_safe
  end
end
