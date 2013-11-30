window.SC ||= {}
window.SC.trackEvent = (event, metadata = {}) ->
  metadata.event  = event
  metadata.secret = $('body').data('recipient-id')
  
  if metadata.track
    if window.ga?
      # Track event with Analytics:
      window.ga 'send', 'event', 'player', event, "/tracks/#{metadata.track}"
    
    if metadata.secret?
      # Track event with our own implementation:
      $.post "/track_events", metadata
