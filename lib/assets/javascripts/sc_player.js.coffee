window.SC ||= {}
class SC.Player
  constructor: (@widget, @tracks) ->
    @player      = @widget.find('.jplayer')
    @track       = null
    @playing     = false
    @currentTime = '00:00'
    
    @initializeWaveforms()
    @initializePlayer()
  
  initializePlayer: ->
    @player.jPlayer(
      swfPath:  '<%= asset_path("jplayer/Jplayer.swf") %>'
      supplied: 'mp3'
      volume:   0.8,
      cssSelectorAncestor: ''
      cssSelector:
        seekBar: '.loader'
        currentTime: '.current-time'
        playBar: '.location'
        duration: '.track-length'
      ready: => @change @tracks[0] if @tracks.length >= 1
    ).bind(
      $.jPlayer.event.timeupdate,
      (event) => @updateTimer(event)
    ).bind(
      $.jPlayer.event.progress,
      (event) => @updateLoader(event)
    ).bind(
      $.jPlayer.event.waiting,
      (event) => @widget.addClass('player-loading')
    ).bind(
      $.jPlayer.event.playing,
      (event) => @widget.removeClass('player-loading')
    ).bind(
      $.jPlayer.event.ended,
      (event) => @next()
    )
  
  initializeWaveforms: ->
    @widget.find('.player-track').each (index, track) =>
      track = $ track
      $.get(track.data('waveform-url'))
       .done (data) =>
         container = @widget.find('.timeline')
         container.addClass('has-waveform')
         wrapper = container
                     .find('.waveforms')
                     .append("""
                       <div class="waveform-wrapper"
                            data-track-id="#{track.data('track-id')}"
                            data-fill-color="#{track.data('waveform-color')}">
                       </div>
                      """)
                     .find(".waveform-wrapper[data-track-id='#{track.data('track-id')}']")
         
         new SC.Waveform(wrapper, data)
  
  updateLoader: (event) ->
    status = event.jPlayer.status
  
  updateTimer: (event) ->
    status = event.jPlayer.status
    @widget.removeClass('player-loading') if @currentTime > 0
  
  perform: (args...) ->
    @player.jPlayer args...
  
  isPlaying: ->
    @playing
  
  next: ->
    SC.trackEvent 'next-track', track: @track?.attr('data-track-id'), timer: @currentTime
    
    if nextTrack = @tracks[@tracks.index(@track) + 1]
      @change nextTrack
    else
      @change @tracks[0]
    @play()
  
  prev: ->
    SC.trackEvent 'previous-track', track: @track?.attr('data-track-id'), timer: @currentTime
    
    if prevTrack = @tracks[@tracks.index(@track) - 1]
      @change prevTrack
    else
      @change @tracks[@tracks.length - 1]
    @play()
  
  play: (args...) ->
    SC.trackEvent 'play-track', track: @track?.attr('data-track-id'), timer: @currentTime
    
    unless @playing
      @playing = true
      @perform 'play', args...
  
  pause: (args...) ->
    SC.trackEvent 'pause-track', track: @track?.attr('data-track-id'), timer: @currentTime
    
    if @playing
      @playing = false
      @perform 'pause', args...
  
  updateTrackInfo: ->
    trackInfo = @widget.find('.time')
    artist    = @track.find('.track-artist').text()
    title     = @track.find('.track-title').text()
    
    trackInfo.find('.track-artist').text(artist)
    trackInfo.find('.track-title').text(title)
  
  change: (track, trackChange = false) ->
    @track = $ track
    
    @widget.find(".waveform-wrapper")
           .css(visibility: 'hidden')
    @widget.find(".waveform-wrapper[data-track-id='#{@track.data('track-id')}']")
           .css(visibility: 'visible')
    
    if trackChange
      SC.trackEvent 'change-track', track: @track?.data('track-id'), timer: @currentTime
    
    # Set the track so we can play it:
    file = @track.data('attachment-url')
    @perform 'setMedia', mp3: file
    
    # If we're already playing, start playing the track we're switching to:
    if @playing
      @pause()
      @updateTrackInfo()
      @play()
    else
      @updateTrackInfo()
