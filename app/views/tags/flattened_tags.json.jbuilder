@visited = Set.new
@nodes = []
def traverse(json, tag, group_name)
	return if(@visited.include? tag.id)
	@visited << tag.id
	@nodes << [tag, group_name]
	edges = tag.edges
	unless edges.empty?
		edges.each do |e|
			traverse(json, e.target_tag, group_name)
		end
	end
end

Tag.where.not(id: Edge.select(:target_id).distinct).each do |tag|
	@visited = Set.new
	group_name = tag.name.to_s.gsub(/\s/, '-')
	traverse(json, tag, group_name)
end


@nodes = (@nodes.sort{ |n1, n2| n1[0].posts.length <=> n2[0].posts.length}).reverse
json.children @nodes.each do |node|
	tag = node[0]
	json.id tag.id
	json.name tag.name
	json.value tag.posts.length + 1
	json.group node[1]
end