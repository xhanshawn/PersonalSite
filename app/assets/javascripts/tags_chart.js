
// function to build a bubble chart
function build_bubble_chart() {

  // if($('#bubble-chart svg').length) return;

  var width = (window.innerWidth > 0) ? window.innerWidth : screen.width;

  var diameter = width * 0.5,
      format = d3.format(",d"),
      color = d3.scale.category20c();

  var tag_comp = function(tag1, tag2){
    return -(tag1.value - tag2.value);
  }


  var bubble = d3.layout.pack()
      .sort(tag_comp)
      .size([diameter, diameter])
      .padding(3);


  var svg = d3.select("#bubble-chart")
      .append("svg")
      .attr("width", diameter)
      .attr("height", diameter)
      .attr("class", "tags-bubble-chart");



  d3.json("/tags.json", function(error, root) {
    if (error) throw error;

    var nodes = bubble.nodes(classes(root))
        .filter(function(d) { return !d.children; });

    
    var node = svg.selectAll(".node")
        .data(nodes)
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

    node.append("title")
        .text(function(d) { return d.className + ": " + format(d.value); });

    node.append("svg:a").attr("xlink:href", function(d){ return "/tags/" + d.id })
        .append("circle")
        .attr("r", function(d) { return d.r; })
        .style("fill", function(d) { return color(d.className); });


    node.select('a')
        .append("text")
        .text(function(d) { return d.className.substring(0, d.r / 3); })
        .style("font-size", function(d) { return Math.min(2 * d.r, (2 * d.r - 8) / this.getComputedTextLength() * 10) + "px"; })
        .attr("dy", ".3em")
        .style("text-anchor", "middle");
        

  });

  // Returns a flattened hierarchy containing all leaf nodes under the root.
  function classes(root) {
    var classes = [];

    function recurse(name, node) {
      if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
      else classes.push({packageName: name, className: node.name, value: node.size, id: node.id});
    }

    recurse(null, root);

    return {children: classes};
  }

  d3.select(self.frameElement).style("height", diameter + "px");

}











// function to build a force directed graph for tags
function build_force_directed_graph() {

  // if($('#force-directed-graph svg').length) return;

  var device_width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
  // var width = 960,
  //  height = 500;
  var width = device_width * 0.5,
    height = device_width * 0.4;

  var color = d3.scale.category20();

  var force = d3.layout.force()
      .charge(-120)           // repulsion, attraction
      .chargeDistance(1000)    
      .linkDistance(30)
      .linkStrength(0.01)     // compact or sparse
      .friction(0.85)         // liveness, activity
      .gravity(0.08)          // gravity
      .size([width, height]); 

  var svg = d3.select("#force-directed-graph").append("svg")
      .attr("width", width)
      .attr("height", height);



  var source_node, target_node, drag_line, drawing;

  var link = svg.append('svg:g').attr('class', 'link-panel').selectAll(".link"),
      node = svg.append('svg:g').selectAll(".node");

  // var link = svg.append('svg:g').attr('class', 'link-panel').selectAll(".link"),
  //     node = svg.selectAll(".node");

  var graph_data;

  d3.json("edges.json", function(error, graph) {

    if (error) throw error;

    graph_data = graph;

    drawing = false;

    draw_graph(graph);

    force.on("tick", function() {
      link.attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

      node.attr("cx", function(d) { return d.x; })
          .attr("cy", function(d) { return d.y; });
    });

  });


  function draw_graph(graph){
    
    drag_line = d3.select('.link-panel').append("svg:path")
                       .attr('d', 'M0,0L0,0');   

    link = link.data(graph.links);
    link.enter().append("svg:line")
        .attr("class", "link")
        .style("stroke-width", function(d) { return Math.sqrt(d.value); })
        .style("stroke", "#999");

    link.exit().remove();

    node = node.data(graph.nodes);
    node.enter().append("svg:circle")
        .attr("class", "node")
        .attr("r", 10)
        .style("fill", function(d) { return color(d.group); })
        .call(force.drag);

    node.append("title")
        .text(function(d) { return d.name; });
    
    node.exit().remove();
    force.nodes(graph.nodes)
         .links(graph.links)
         .start();

    node.on("mousedown", function(d){


      if(!drawing || target_node) return;

      if(!source_node) {

        source_node = d3.select(this);
        highlight_node(source_node); 

      } else if(source_node === d3.select(this)){

        
        reset_node(source_node);
        source_node = null;
      } else {

        target_node = d3.select(this);
        highlight_node(target_node);
      }      
    });

  }



  

  svg.on("mousemove", function(e){

    console.log(drawing);
    if(!source_node || !drawing) return;
    var coordinates = [0, 0];
    coordinates = d3.mouse(this);
    var x = coordinates[0];
    var y = coordinates[1];
    drag_line
        .style("stroke", "#000").style("stroke-width", 4)
        .attr('d', 'M' + source_node.attr('cx') + ',' + source_node.attr('cy') + 'L' + x +',' + y);     
  });

  svg.on("mouseup", function(e){
    if(!drawing) return;

    drag_line
      .style("stroke", "#000").style("stroke-width", 4)
      .attr('d', 'M0,0L0,0'); 
    if(target_node) {

      var obj = {
        'source': graph_data.nodes[source_node.datum().index],
        'target': graph_data.nodes[target_node.datum().index]
      };

      graph_data.links.push(obj);
      console.log(obj);

      console.log(graph_data);

      draw_graph(graph_data);

      source_node = null;
      target_node = null;

    }
        
  });

  var control_panel = $('<div>', {class:'row', id:'control-panel'});
  $('#tags-panel').append(control_panel);

  var hint = $('<p>', {class:'col-md-8 help-block', id:'hint'});
  control_panel.append(hint);

  var default_hint = "click edit button to enter edit mode.",
  edit_hint = "You can edit the graph by click a source node and then click a target node. (press 'esc' to cancel current edge).",
  update_hint = "currently edges cannot be updated.";

  $('#hint').text(default_hint);

  var operate_btn = $('<a>', {class:"btn btn-sm btn-info pull-right", id:"operate-btn", text:"edit"});
  control_panel.append(operate_btn);

  operate_btn.on('click', function(e){
    if($(this).text() === 'edit'){
      drawing = true;
      force.start();
      $('#hint').text(edit_hint);
      $(this).text('update');
    } else if($(this).text() === 'update'){

      drawing = false;
      drag_line
      .style("stroke", "#000").style("stroke-width", 4)
      .attr('d', 'M0,0L0,0');   

      if(source_node) {
        reset_node(source_node);
        source_node = null;
      }
      if(target_node) {
        reset_node(target_node);
        target_node = null;
      }
      $('#hint').text(update_hint);
      $(this).text('edit');
    }
  });


  $(window).on('keyup', function(e) {

    if(e.keyCode === 27) {

      drag_line
      .style("stroke", "#000").style("stroke-width", 4)
      .attr('d', 'M0,0L0,0');   

      if(source_node) {
        reset_node(source_node);
        source_node = null;
      }
      if(target_node) {
        reset_node(target_node);
        target_node = null;
      }
    }
  });

  function highlight_node(circle){
    circle.style("stroke", "#000")
        .style("stroke-width", 3);
  };


  function reset_node(circle){
    circle.style("stroke", "#FFF")
        .style("stroke-width", 0);
  };  
}
