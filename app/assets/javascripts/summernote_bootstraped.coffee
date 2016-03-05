$ ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      height: null,
      minHeight: 200,
      maxHeight: null,
      focus: true               