function build_force_directed_graph() {

	// if($('#force-directed-graph svg').length) return;
	var device_width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
	// var width = 960,
	// 	height = 500;
	var width = device_width * 0.5,
		height = device_width * 0.4;

	var color = d3.scale.category20();

	var force = d3.layout.force()
	    .charge(-120)           // repulsion, attraction
	    .chargeDistance(1000)    
	    .linkDistance(30)
	    .linkStrength(0.01)   	// compact or sparse
	    .friction(0.85)       	// liveness, activity
	    .gravity(0.08)          // gravity
	    .size([width, height]); 

	var svg = d3.select("#force-directed-graph").append("svg")
	    .attr("width", width)
	    .attr("height", height);

	d3.json("edges.json", function(error, graph) {

	  if (error) throw error;

	  force
	      .nodes(graph.nodes)
	      .links(graph.links)
	      .start();

	  var link = svg.selectAll(".link")
	      .data(graph.links)
	      .enter().append("line")
	      .attr("class", "link")
	      .style("stroke-width", function(d) { return Math.sqrt(d.value); })
	      .style("stroke", "#999");

	  var node = svg.selectAll(".node")
	      .data(graph.nodes)
	      .enter().append("circle")
	      .attr("class", "node")
	      .attr("r", 10)
	      .style("fill", function(d) { return color(d.group); })
	      .call(force.drag);

	  node.append("title")
	      .text(function(d) { return d.name; });

	  force.on("tick", function() {
	    link.attr("x1", function(d) { return d.source.x; })
	        .attr("y1", function(d) { return d.source.y; })
	        .attr("x2", function(d) { return d.target.x; })
	        .attr("y2", function(d) { return d.target.y; });

	    node.attr("cx", function(d) { return d.x; })
	        .attr("cy", function(d) { return d.y; });
	  });

	  var clicked_circle;

	  node.on('click', function(){

	  	if(d3.select(this) != clicked_circle) {

	  		if(clicked_circle) clicked_circle.style("stroke", "#FFF")
				.style("stroke-width", 0);

	  		d3.select(this).style("stroke", "#000")
				.style("stroke-width", 3);

				clicked_circle = d3.select(this);
	  	}
	  });

	  node.on("mousedown.drag", function (d) {
		  console.log(d3.event.x + "hello" + d3.event.y);
		});


	});
}