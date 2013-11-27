$(document).ready ->
  $('.cover-drop').each ->
    droppable   = $ this
    buttonText  = droppable.html()
    association = droppable.data('association')
    urlParams   = {}
    
    if association?.indexOf('=') >= 0
      params = association.split('=')
      key    = params[0]
      value  = params[1]
      
      urlParams[key] = value
    
    previewCoverThumbnail = (droppable, uploadId) ->
      alert "preview #{uploadId}"
      thumbnail = droppable.find(".cover-preview .preview[data-upload-id='#{id}'] img.preview-thumbnail")
      alert thumbnail[0]
      
      $(droppable).fineUploader 'drawThumbnail', uploadId, thumbnail[0]
    
    droppable.fineUploader(
      debug: true
      multiple: false
      text:
        dragZone:     buttonText
        uploadButton: buttonText
      validation:
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif']
      request:
        customHeaders: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
        endpoint:      droppable.data('upload-url')
        inputName:     'attachment'
        params:        urlParams
    ).on('error', (event, id, name, reason) ->
      console?.log ["Error", event, id, name, reason]
      
      dropzone = $ event.target
      dropzone.removeClass('upload-started')
              .removeClass('uploading')
      
      dropzone.find('.cover-preview').html('')
    ).on('complete', (event, id, name, reason) ->
      dropzone = $ event.target
      dropzone.removeClass('upload-started')
              .removeClass('uploading')
      
      dropzone.find('.cover-preview').html("""
        <div class="preview" data-upload-id="#{id}">
          <img src="#{reason.thumbnailUrl}" class="preview-thumbnail">
          <input type="hidden" name="#{dropzone.data('file-attribute')}" value="#{reason.id}">
        </div>
      """)
      
      console.log reason
    ).on('submitted', (event, id, name) ->
      dropzone = $ event.target
      dropzone.addClass('upload-started')
      
      # Add the preview:
      dropzone.find('.cover-preview').html("""
        <div class="preview" data-upload-id="#{id}">
          <span class="filename">#{name}</span>
          <span class="loader">
            <span class="loader-inner" style="width:0%"></span>
          </span>
        </div>
      """)
      
    ).on('progress', (event, id, name, uploadedBytes, totalBytes) ->
      dropzone = $ event.target
      dropzone.removeClass('upload-started')
              .addClass('uploading')
      
      preview  = dropzone.find('.cover-preview')
      progress = Math.round(uploadedBytes / totalBytes * 1000) / 10
      
      existing = preview.find(".preview[data-upload-id='#{id}']")
      
      if existing[0]
        existing.find('.loader-inner').css width: "#{progress}%"
      else
        preview.html("""
          <div class="preview" data-upload-id="#{id}">
            <span class="filename">#{name}</span>
            <span class="loader">
              <span class="loader-inner" style="width:#{progress}%"></span>
            </span>
          </div>
        """)
    )