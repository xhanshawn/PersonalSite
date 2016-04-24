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
	current_btn = $('.graph-btn .active')

	draw('bubble-chart')
	build_bubble_chart()

	$('.graph-btn').click ->
		$(this).addClass('active').siblings().removeClass('active')
		if(current_btn != this)
			current_btn = this
			if(this.id == 'bubble-chart-btn')
				draw('bubble-chart')
				build_bubble_chart()
			else if(this.id == 'force-directed-graph-btn')
				draw('force-directed-graph')
				build_force_directed_graph()



