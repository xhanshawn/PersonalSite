# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	return unless $('.about').length
	chart = $ '<div>'
	chart.attr 'id', 'bubble-chart'
	$('#tags-panel').empty()
	$('#tags-panel').append(chart)
	build_bubble_chart()