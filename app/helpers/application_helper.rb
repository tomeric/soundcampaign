module ApplicationHelper
  def site_name
    Settings['name']
  end
  
  def site_subtitle
    Settings['subtitle']
  end
  
  def title(new_title = nil)
    if new_title.present?
      @page_title = new_title
    else
      @page_title || ""
    end
  end
  
  def page_title
    if title.present?
      parts = [title, site_name]
    else
      parts = [site_name, site_subtitle]
    end
    
    page_title = strip_tags parts.compact.join(' — ')
    page_title.html_safe
  end
  
  def flash_messages
    return unless flash.present?
    
    messages = []
    
    flash.each do |html_class, message|
      if message.present?
        messages << render(
          partial: 'shared/flash_message',
          locals:  {
            html_class: html_class.to_s,
            message:    message
          }
        )
        
        flash[html_class] = nil
      end
    end
    
    messages.join.html_safe
  end
  
  def duration_to_clock(seconds)
    if seconds > 1.hour
      Time.at(seconds).utc.strftime('%H:%M:%S')
    else
      Time.at(seconds).utc.strftime('%M:%S')
    end
  end
end
