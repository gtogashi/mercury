Mercury.modalHandlers.insertmedia = ->
  # make the inputs work with the radio buttons, and options
  @element.find('label input').click (event) ->
    $(@).closest('label').next('.selectable').focus()

  @element.find('.selectable').focus (event) =>
    element = $(event.target)
    element.prev('label').find('input[type=radio]').prop("checked", true)

    @element.find(".media-options").hide()
    @element.find("##{element.attr('id').replace('media_', '')}").show()
    @resize(true)

  # get the selection and initialize its information into the form
  if Mercury.region && Mercury.region.selection
    selection = Mercury.region.selection()

    # if we're editing an image prefill the information
    if image = selection.is('img')
      @element.find('#media_image_url').val(image.attr('src'))
      @element.find('#media_image_alignment').val(image.attr('align'))

    # if we're editing an iframe (assume it's a video for now)
    if iframe = selection.is('iframe')
      src = iframe.attr('src')
      if src.indexOf('http://www.youtube.com') > -1
        # it's a youtube video
        @element.find('#media_youtube_url').val("http://youtu.be/#{src.match(/\/embed\/(\w+)/)[1]}")
        @element.find('#media_youtube_width').val(iframe.attr('width'))
        @element.find('#media_youtube_height').val(iframe.attr('height'))
        @element.find('#media_youtube_url').focus()
      else if src.indexOf('http://player.vimeo.com') > -1
        # it's a vimeo video
        @element.find('#media_vimeo_url').val("http://vimeo.com/#{src.match(/\/video\/(\w+)/)[1]}")
        @element.find('#media_vimeo_width').val(iframe.attr('width'))
        @element.find('#media_vimeo_height').val(iframe.attr('height'))
        @element.find('#media_vimeo_url').focus()

  # build the image or youtube embed on form submission
  @element.find('form').submit (event) =>
    event.preventDefault()

    type = @element.find('input[name=media_type]:checked').val()

    switch type
      when 'image_url'
        attrs = {src: @element.find('#media_image_url').val()}
        attrs['align'] = alignment if alignment = @element.find('#media_image_alignment').val()
        value = $('<img>', attrs)
      when 'youtube_url'
        code = @element.find('#media_youtube_url').val().replace('http://youtu.be/', '')
        value = $('<iframe>', {
          width: @element.find('#media_youtube_width').val() || 560,
          height: @element.find('#media_youtube_height').val() || 349,
          src: "http://www.youtube.com/embed/#{code}?wmode=transparent",
          frameborder: 0,
          allowfullscreen: 'true'
        })
      when 'vimeo_url'
        code = @element.find('#media_vimeo_url').val().replace('http://vimeo.com/', '')
        value = $('<iframe>', {
          width: @element.find('#media_vimeo_width').val() || 400,
          height: @element.find('#media_vimeo_height').val() || 225,
          src: "http://player.vimeo.com/video/#{code}?title=1&amp;byline=1&amp;portrait=0&amp;color=ffffff",
          frameborder: 0,
        })

    Mercury.trigger('action', {action: 'insertHTML', value: value})
    Mercury.modal.hide()