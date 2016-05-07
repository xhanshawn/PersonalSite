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

		$(btn).addClass('active').siblings().removeClass('active')
		if(current_btn != btn)
			current_btn = btn
			window.history.pushState("", "", "/tags?graph_type=" + btn.id.split('-btn')[0])
			if(btn.id == 'bubble-chart-btn')
				draw('bubble-chart')
				build_bubble_chart()
			else if(btn.id == 'force-directed-graph-btn')
				draw('force-directed-graph')
				build_force_directed_graph()

				

	click_button($('.graph-btns .active')[0])
	$('.graph-btn').click -> click_button(this)




root = exports ? this	
root.update_graph = (graph_data)->
	# for node in graph_data.nodes
	# 	update_node node

	for edge in graph_data.links
		if(edge.id)
			update_edge edge
		else
			create_edge edge

	build_force_directed_graph()



update_node = (node) ->
	console.log node

update_edge = (edge) ->
	$.ajax '/edges/' + edge.id + '.js',
		type: 'PATCH'
		data: edge: params_of edge
		error: (jqXHR, textStatus, errorThrown) ->
			console.log 'error:' + errorThrown
			$('#hint').text('update failed. please note that currently only developers can update the edges on the graph.');
		success: (data, textStatus, jqXHR) ->

create_edge = (edge) ->
	$.post 'edges.js',
		edge: params_of edge


params_of = (edge) ->
	{
		tag_id: edge.source.id,
		target_id: edge.target.id,
		edge_type: edge.edge_type
	}



