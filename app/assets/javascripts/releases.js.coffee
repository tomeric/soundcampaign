$(document).ready ->
  $('.track-uploader').each ->
    trackDroppable = $ this
    buttonText = trackDroppable.html()
    trackDroppable.fineUploader(
      debug: true
      text:
        dragZone:     buttonText
        uploadButton: buttonText
      validation:
        allowedExtensions: ['mp3']
      request:
        customHeaders: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
        endpoint: trackDroppable.attr('data-upload-url')
        inputName: 'attachment'
      multiple: true
    ).on('error', (event, id, name, reason) ->
      console?.log ["Error", event, id, name, reason]
      
      # Remove the "Your track is uploading" message so a user can select a
      # file that will not generate an error instead:
      dropzone = $ event.target
      dropzone.removeClass('upload-started')
    
    ).on('complete', (event, id, name, reason) ->
      # Remove the "Your track is uploading" message so a user can select the
      # next track that needs to be uploaded:
      dropzone = $ event.target
      dropzone.removeClass('upload-started')
      
      # Append the template returned by the server to the track list:
      $('#track_list').append(reason.template)
      
      # Remove the track from the queue of uploading files:
      trackList = dropzone.find('.tracks')
      trackList.find(".track[data-upload-id='#{id}']").remove()
    
    ).on('submitted', (event, id, name) ->
      dropzone = $ event.target
      
      # Adding this class hides the "Add your track message" and shows the 
      # "Your track is uploading" message instead. If the browser doesn't
      # support showing a progress bar, this message will stay until the file
      # has been uploaded:
      dropzone.addClass('upload-started')
      
      # Replace generic "your track" with the actual name of the file being
      # uploaded:
      dropzone.find('.track-name').html(name)
    
    ).on('progress', (event, id, name, uploadedBytes, totalBytes) ->
      dropzone = $ event.target
      
      # Remove the "Your track is uploading" message so the user can
      # select multiple files that need to be uploaded at the same
      # time:
      dropzone.removeClass('upload-started')
      
      # Add a track to the queue of uploading tracks, or update it's
      # progress bar:
      trackList = dropzone.find('.tracks')
      progress  = Math.round(uploadedBytes / totalBytes * 1000) / 10
      
      existing = trackList.find(".track[data-upload-id='#{id}']")
      if existing
        existing.find('.loader-inner').css width: "#{progress}%"
      else
        trackTemplate = """
          <li class="track" data-upload-id="#{id}">
            <!--
            <a class="track-cancel" href="#verwijderen"></a>
            -->
            <span class="filename">#{name}</span>
            <span class="loader">
              <span class="loader-inner" style="width:#{progress}%"></span>
            </span>
          </li>
        """
        trackList.append(trackTemplate)
      
    )
    
    trackDroppable.find('.qq-upload-button > div > *').click (e) ->
      $(this).parent().parent().click()
