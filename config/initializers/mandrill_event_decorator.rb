Mandrill::WebHook::Processor.class_eval do
  define_method :wrap_payload do |raw_event_payload|
    MandrillEventDecorator[raw_event_payload]
  end
end
