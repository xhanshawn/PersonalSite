tags_set = {}

format_tag = (tag_name) ->
	tag_name.replace(/\n|\r/g, "").trim().toLowerCase()

remove_tag = -> 
	tag_name = format_tag $(this).parent().text()
	tags_set[tag_name] = false
	$(this).parent().remove()

$ ->
	$('.tag-remove-sign').click remove_tag

	$('.tag-button').each ->
	
		tag_name = format_tag $(this).text()
		console.log tag_name


		tags_set[tag_name] = true
		console.log(tags_set)

	$('#add-tag-button').click ->
		tag_name = $('#new-tag-input').val()
		tag_name = format_tag tag_name

		if(tag_name is '' or tags_set[tag_name])
			return

		tags_set[tag_name] = true

		new_tag = $ '<a>'
		new_tag.addClass('btn btn-info btn-xs')

		remove_sign = $ '<span>'
		remove_sign.addClass('glyphicon glyphicon-remove-sign tag-remove-sign')
		remove_sign.click remove_tag

		new_tag.html(tag_name + " ")
		new_tag.append(remove_sign)

		$('#tags').append(new_tag)
		$('#tags').append(' ')
	



