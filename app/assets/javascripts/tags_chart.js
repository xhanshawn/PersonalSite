$(document).ready(function() {
  if(!$('.tags')) return;

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


  var svg = d3.select("#tags-chart")
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

});
