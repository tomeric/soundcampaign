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
    ).on('error',   (event, id, name, reason) ->
      alert "Error!"
      console.log event
      console.log id
      console.log name
      console.log reason
    ).on('complete', (event, id, name, reason) ->
      $('#track_list').append(reason.template)
      console.log event
      console.log id
      console.log name
      console.log reason
    )
    
    trackDroppable.find('.qq-upload-button > div > *').click (e) ->
      $(this).parent().parent().click()
