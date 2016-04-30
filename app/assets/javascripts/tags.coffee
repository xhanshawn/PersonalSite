# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

draw = (id_str) -> 
	chart = $ '<div>'
	chart.attr 'id', id_str
	$('#tags-panel').empty()
	$('#tags-panel').append(chart)

$ -> 
	return unless $('.tags').length


	# current_btn = $('.graph-btns .active')
	current_btn = null
	# draw('bubble-chart')
	# build_bubble_chart()

	
	click_button = (btn) ->
		console.log btn
		$(btn).addClass('active').siblings().removeClass('active')
		if(current_btn != btn)
			current_btn = btn
			window.history.pushState("", "", "/tags?graph_type=" + btn.id.split('-btn')[0])
			if(btn.id == 'bubble-chart-btn')
				draw('bubble-chart')
				build_bubble_chart()
			else if(btn.id == 'force-directed-graph-btn')
				# window.history.pushState('force-directed-graph', 'graph_type', '/tags');
				draw('force-directed-graph')
				build_force_directed_graph()

				

	click_button($('.graph-btns .active')[0])
	$('.graph-btn').click -> click_button(this)
		



