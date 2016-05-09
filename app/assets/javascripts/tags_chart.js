var helpers = {
  tooltip: function(text) {

    return function(selection){
      selection.on('mouseover.tooltip', mouseover)
      .on('mousemove.tooltip', mousemove)
      .on('mouseout.tooltip', mouseout);
    }

    function mouseover(d){
      var svg = d3.select("#force-directed-graph svg");
      var mouse = d3.mouse(svg.node());
      var tool = svg.append('g')
                    .attr({'id': 'nametooltip', transform: 'translate(' + (mouse[0] + 5) + ',' + (mouse[1] + 10) + ')'});
      var textNode = tool.append('text').text(d.name).node();

      tool.append('rect')
          .attr({ height: textNode.getBBox().height,
                  width: textNode.getBBox().width,
                  transform: 'translate(0, -16)'
                });
      tool.select('text')
          .remove();
      tool.append('text')
          .text(d.name);
    }


    function mousemove(d){

    }

    function mouseout(d){
      var node = d3.select(this);
      $('#nametooltip').remove();
    }

  }
};


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

  var width = 800,
   height = 500;

  if(device_width < width) {
    width = device_width,
    height = device_width * 500 / 960;
  }

  var color = d3.scale.category20();

  var force = d3.layout.force()
      .charge(-120)           // repulsion, attraction
      .chargeDistance(1000)    
      .linkDistance(30)
      .linkStrength(0.2)     // compact or sparse
      .friction(0.85)         // liveness, activity
      .gravity(0.08)          // gravity
      .size([width, height]); 

  $('#force-directed-graph').html('');
  var svg = d3.select("#force-directed-graph").append("svg")
      .attr("width", width)
      .attr("height", height);



  var source_node, target_node, drag_line, drawing, edge_type;

  var link = svg.append('svg:g').attr('class', 'link-panel').selectAll(".link"),
      node = svg.append('svg:g').attr('class', 'node-panel').selectAll(".node");


  var link_color = d3.scale.category10();
  // var link = svg.append('svg:g').attr('class', 'link-panel').selectAll(".link"),
  //     node = svg.selectAll(".node");

  var legend = svg.append("g")
                  // .attr("transform","translate(50,30)")
                  .attr("fill","black")
                  .style("font-size","12px")
                  .selectAll('.legend');


  var defs = svg.append("svg:defs");

  defs.append("svg:marker")    // This section adds in the arrows
      .attr({
        "id":"arrow",
        "viewBox":"0 -5 10 10",
        "refX":20,
        "refY":0,
        "markerWidth":6,
        "markerHeight":6,
        "orient":"auto"
      })
      .append("svg:path")
        .attr("d", "M0,-5L10,0L0,5");

  defs.append("svg:marker")
      .attr({
        "id":"drag_line_arrow",
        "viewBox":"0 -5 10 10",
        "refX":5,
        "refY":0,
        "markerWidth":6,
        "markerHeight":6,
        "orient":"auto"
      })
      .append("svg:path")
        .attr("d", "M0,-5L10,0L0,5");




  var graph_data;


  update_graph_data();

  function update_graph_data() {
    d3.json("edges.json", function(error, graph) {

      if (error) throw error;

      // cache existing graph data
      graph_data = graph;

      edge_type = graph_data.edge_types[0];

      // boolean to enable editing mode
      drawing = false;

      // function to draw or update the graph
      draw_graph(graph);

      // hide_links();

      force.on("tick", function() {
        link.attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });

        node.attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; });
      });

    });

  }

  

  
  function hide_links(){

    $('.link').hide();
    $('.link.' + edge_type.name).show();
    

    // var current_links = [];

    // graph_data.links.forEach(function(d){
    //   if(d.edge_type === edge_type.name) current_links.push(d);
    // });


    // console.log(current_links);
    // link = link.data(current_links);
    // link.enter().append("svg:line")
    //     .attr("class", function(d) { console.log(d);return 'link ' + d.edge_type; })
    //     .style("stroke-width", function(d) { return 1.5; })
    //     .style("stroke", function(d) { 
    //       return link_color(d.edge_type);})
    //     .attr("marker-end", "url(#arrow)")
    //     .append("title")
    //     .text(function(d) {
    //       return d.edge_type; 
    //     });

    // link.exit().remove();

    // force.links(current_links).start();
  }



  function draw_graph(graph){
    
    // update links
    
    link = link.data(graph.links);
    link.enter().append("svg:line")
        .attr("class", function(d) {return 'link ' + d.edge_type; })
        .style("stroke-width", function(d) { return 1.5; })
        .style("stroke", function(d) { 
          return link_color(d.edge_type);})
        .attr("marker-end", "url(#arrow)")
        .append("title")
        .text(function(d) {
          return d.edge_type; 
        });

    link.exit().remove();

    // update node
    node = node.data(graph.nodes);
    node.enter().append("svg:circle")
        .attr("class", "node")
        .attr("id", function(d){ return "tag" + d.id; })
        .attr("r", 10)
        .style("fill", function(d) { return color(d.group); })
        .call(helpers.tooltip(function (d) {return d.name;}))
        .call(force.drag)
        .append("title")
        .text(function(d) { return d.name; });

    // node;
    
    
    node.exit().remove();


    // restart the graph
    force.nodes(graph.nodes)
         .links(graph.links)
         .start();

    // update selected nodes
    node.on("mousedown", function(d){


      if(!drawing || target_node) return;

      if(!source_node) {

        source_node = d3.select(this);
        highlight_node(source_node); 

      } else if(source_node.attr('id') === d3.select(this).attr('id')){
        reset_node(source_node);
        source_node = null;
      } else {
        target_node = d3.select(this);
        highlight_node(target_node);
      }      
    });


    // line for drawing new line
    d3.selectAll('.link-panel path').remove();
    drag_line = d3.select('.link-panel').append("svg:path")
                      .attr('d', 'M0,0L0,0');   


    if(graph_data.edge_types.length > 0) {

      var legend_rectsize = 18;
      var legend_spacing = 4;

      legend = legend.data(graph_data.edge_types);

      legend.enter().append('svg:g')
            .attr('transform', function(d, i){
              return 'translate(5, ' + i *(legend_rectsize + legend_spacing) + ')';
            })
            .attr('class', 'legend');

      legend.html('');
      
      var legend_text_node = legend.append('text')
            .attr('x', legend_rectsize + legend_spacing * 2)
            .attr('y', legend_rectsize - legend_spacing)
            .text(function(d) { return d.name + ' ' + d.num; }).node();

      legend.append('rect')
            .attr('width', legend_rectsize)
            .attr('height', 5)
            .attr('x', legend_spacing)
            .attr('y', legend_spacing)
            .style('fill', function(d){return link_color(d.name);});

      legend.append('rect')
            .attr('class', function(d) { 
              if(d === edge_type) return 'highlighted';
              else return '' 
            })
            .attr('width', legend_rectsize + legend_spacing * 3 +legend_text_node.getBBox().width)
            .attr('height', legend_text_node.getBBox().height + legend_spacing * 2)
            .attr('rx', 3)
            .attr('ry', 3)
            .attr('fill-opacity', '0.0');
      

      legend.selectAll('rect').on('mousedown', function(e){
        d3.selectAll('.legend rect').classed('highlighted', false);
        d3.select(this).classed('highlighted', true);
        edge_type = d3.select(this).datum();
        hide_links();
      });
    }

    
  }

  

  

  
  // update line
  svg.on("mousemove", function(e){

    if(!source_node || !drawing) return;
    var coordinates = [0, 0];
    coordinates = d3.mouse(this);
    var x = coordinates[0];
    var y = coordinates[1];
    drag_line
        .style("stroke", "#000").style("stroke-width", 2)
        .attr('d', 'M' + source_node.attr('cx') + ',' + source_node.attr('cy') + 'L' + x +',' + y)
        .attr("marker-end", "url(#drag_line_arrow)");     
  });

  // add new links or redo nodes selection
  svg.on("mouseup", function(e){

    if(!drawing) return;

    d3.selectAll('.link-panel path').remove();
    if(target_node) {

      var obj = {
        'source': graph_data.nodes[source_node.datum().index],
        'target': graph_data.nodes[target_node.datum().index],
        'edge_type': edge_type.name
      }; 

      edge_type.num += 1;

      graph_data.links.push(obj);

      console.log(obj);

      console.log(graph_data);

      console.log(edge_type);

      draw_graph(graph_data);

      link_nodes[source_node.attr('id')] = true;
      link_nodes[target_node.attr('id')] = true;

      source_node = null;
      target_node = null;

    } else {
      
      drag_line = d3.select('.link-panel').append("svg:path")
                      .attr('d', 'M0,0L0,0'); 
    }
        
  });

  $('#control-panel').remove();
  // div row for editing the graph
  var control_panel = $('<div>', {class:'row', id:'control-panel'});
  $('#tags-panel').append(control_panel);

  // place to update hints
  var hint = $('<p>', {class:'col-md-8 help-block', id:'hint'});
  control_panel.append(hint);

  // hints
  var default_hint = "click edit button to enter edit mode.",
  edit_hint = "You can edit the graph by click a source node and then click a target node. (press 'esc' to cancel current edge).",
  update_hint = "currently only developers can update edges.";

  $('#hint').text(default_hint);

  // button for start editing and update
  var operate_btn = $('<a>', {class:"btn btn-sm btn-info pull-right", id:"operate-btn", text:"edit"});
  control_panel.append(operate_btn);


  var link_nodes = {};

  // handling click for operate btn
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
      
      for(var e in link_nodes){
        if(link_nodes[e]){

          link_nodes[e] = false;
          reset_node(d3.select('#' + e));
        }
      };

      $('#hint').text(update_hint);
      $(this).text('edit');

      $('.link').show();

      update_graph(graph_data);

    }
  });



  // listening key up. 
  // esc to cancel current link and nodes
  $(window).on('keyup', function(e) {

    if(e.keyCode === 27) {

      drag_line.remove(); 

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

  // function to highlight node
  function highlight_node(circle){
    circle.classed('highlighted', true);
    return;
    circle.style("stroke", "#000")
        .style("stroke-width", 3);

  };

  // funtion to reset highlight node
  function reset_node(circle){
    if(link_nodes[circle]) return;
    circle.style("stroke", "#FFF")
        .style("stroke-width", 0);
  };  
}


function build_tags_tree(){

  var device_width = (window.innerWidth > 0) ? window.innerWidth : screen.width;

  var width = 800,
   height = 800;

  if(device_width < width) {
    width = device_width,
    height = device_width;
  }

  var cluster = d3.layout.tree()
      .size([height, width - 160]);

  var diagonal = d3.svg.diagonal()
      .projection(function(d) { return [d.y, d.x]; });

  var svg = d3.select("#tags-tree").append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(50,0)");

  d3.json("tags.json?struct_type=tree", function(error, root) {
    if (error) throw error;

    var nodes = cluster.nodes(root),
        links = cluster.links(nodes);

    var link = svg.selectAll(".link")
        .data(links)
      .enter().append("path")
        .attr("class", "link")
        .attr("d", diagonal);

    var node = svg.selectAll(".node")
        .data(nodes)
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

    node.append("circle")
        .attr("r", 4.5);

    node.append("text")
        .attr("dx", function(d) { return d.children ? -8 : 8; })
        .attr("dy", 3)
        .style("text-anchor", function(d) { return d.children ? "end" : "start"; })
        .text(function(d) { return d.name; });
  });

  d3.select(self.frameElement).style("height", height + "px");


  
}
