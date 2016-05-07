$ ->
  $(document).on 'click', 'a[href^="#"]', (e) ->
    # target element id
    id = $(this).attr('href')

    # target element
    $id = $(id)

    # prevent standard hash navigation (avoid blinking in IE)
    e.preventDefault();


    if ($id.length == 0) 
      $('body, html').animate({scrollTop: 0})
    else 
      # top position relative to the document
      pos = $(id).offset().top
      # nimated top scrolling
      $('body, html').animate({scrollTop: pos - 60})