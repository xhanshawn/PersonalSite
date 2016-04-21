if(!$('.posts')) 
		return
# hash set for no duplicate tags
tags_set = {}

# format tag name like trim and remove line breaks
format_tag = (tag_name) ->
	tag_name.replace(/\n|\r/g, "").trim().toLowerCase()

# remove tag element and tag name from hash set
remove_tag = -> 
	tag_name = format_tag $(this).parent().text()
	tags_set[tag_name] = false
	$(this).parent().remove()

# add hidden input for tag to send as parameters
add_tag = (tag_name, tag_button) ->
	hidden_input = $ '<input>'
	hidden_input.attr 'type', 'hidden'
	hidden_input.attr 'name', 'tags[]'
	hidden_input.attr 'id', 'tags_'
	hidden_input.attr 'value', tag_name
	tag_button.append hidden_input

$ ->
	$('.tag-remove-sign').click remove_tag  
	# add click handler for remove sign

	# add existing tags into the tag set
	$('.tag-button').each ->
	
		tag_name = format_tag $(this).text()
		console.log tag_name

		tags_set[tag_name] = true

	# click handler for add tag button
	$('#add-tag-button').click ->
		tag_name = $('#new-tag-input').val()
		tag_name = format_tag tag_name

		if(tag_name is '' or tags_set[tag_name])
			$('#tag-notice').text "The tag is duplicated or invalid"
			return
		else
			$('#tag-notice').text "The tag has been added successfully"

		tags_set[tag_name] = true

		# add button
		new_tag = $ '<span>'
		new_tag.addClass('btn btn-info btn-xs')

		# add remove sign
		remove_sign = $ '<span>'
		remove_sign.addClass('glyphicon glyphicon-remove-sign tag-remove-sign')
		remove_sign.click remove_tag

		new_tag.html(tag_name + " ")
		new_tag.append(remove_sign)

		add_tag tag_name, new_tag

		$('#tags').append(new_tag)
		$('#tags').append(' ')
	



