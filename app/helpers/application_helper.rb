module ApplicationHelper
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
end
