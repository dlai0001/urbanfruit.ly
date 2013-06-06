Ember.TEMPLATES["dnd-image-upload"] = App.Templates.get("dnd-image-upload")
App.DndImageUploadView = Ember.View.extend(
  templateName: "dnd-image-upload",
  value:null,
  didInsertElement: ( ->
    console.log "DID INSERT VIEW!!!!!!!"
    console.log @
    dropZone = @$("#filedrop")[0]

    # Create a lambda function so we can pass along this view.
    dragAndDropView = @
    lambdaFunc = ((evt)->
      # It's really strange, but highlighting has to be removed here.
      dropTargetElement = $(@)
      dropTargetElement.removeClass('highlight-div-drag-enter')
      dragAndDropView.handleFileSelect(evt, dragAndDropView, dropTargetElement)
    )

    dropZone.addEventListener "dragover", @handleDragOver, false
    dropZone.addEventListener "drop", lambdaFunc, false
    dropZone.addEventListener "dragenter", @handleDragEnter, false
    dropZone.addEventListener "dragleave", @handleDragLeave, false
  )



  handleDragOver: ((evt) ->
    evt.stopPropagation()
    evt.preventDefault()
    evt.dataTransfer.dropEffect = "copy" # Explicitly show this is a copy.
    return
  )

  handleDragEnter: ((evt) ->
    $(@).addClass('highlight-div-drag-enter')
    return
  )

  handleDragLeave: ((evt) ->
    $(@).removeClass('highlight-div-drag-enter')
    return
  )

  handleFileSelect: ((evt, viewObj, dndTargetElement) ->
    evt.stopPropagation()
    evt.preventDefault()

    files = evt.dataTransfer.files # FileList object.

    reader = new FileReader()

    fileDropTarget = $(@)

    reader.onload = ((theFile) ->
      (e) ->
        # Render thumbnail.
        dndTargetElement.attr "src", e.target.result
        return

    )(files[0])
    reader.readAsDataURL files[0]

    ## Need to figure out how to pass the controller here.
    viewObj.set('value', files[0])
    return
  )


  dataURItoBlob: ((dataURI) ->
    binary = atob(dataURI.split(",")[1])
    array = []
    i = 0

    while i < binary.length
      array.push binary.charCodeAt(i)
      i++
    return new Blob([new Uint8Array(array)],
      type: "image/jpeg"
    )
  )

)

