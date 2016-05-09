@visited = Set.new

def build_tree(json, tag)
	return if(@visited.include? tag.id)
	@visited << tag.id
	json.name tag.name
	# json.size tag.posts.length + 1
	edges = Edge.where(tag_id: tag.id).to_a
	unless edges.empty?
		json.children edges.each do |e|
			build_tree(json, e.target_tag)
		end
	end
end

# puts Tag.where.not(id: Edge.select(:target_id).distinct)
json.name "archare"
json.children Tag.where.not(id: Edge.select(:target_id).distinct).each do |tag|
	@visited = Set.new
	build_tree(json, tag)
end
