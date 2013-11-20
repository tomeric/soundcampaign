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
    )
    
    trackDroppable.find('.qq-upload-button > div > *').click (e) ->
      $(this).parent().parent().click()
