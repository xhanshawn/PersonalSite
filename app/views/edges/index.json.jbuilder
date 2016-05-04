# array to store group num for each tag by id
group_nums = Array.new

# no tag with 0 id
group_nums[0] = 0

# function to do dfs recursively
def dfs(tag, i, group_nums)
	# puts "id:#{tag.id}"
	unless group_nums[tag.id]
		group_nums[tag.id] = i
		edges = Edge.where('tag_id = ? OR target_id = ?', tag.id, tag.id)
		edges.each do |e|
			dfs(e.target_tag, i, group_nums) unless tag != e.tag or group_nums[e.target_tag.id]
			dfs(e.tag, i, group_nums) unless tag != e.target_tag or group_nums[e.tag.id]
		end
	end
end

# group num, start from 1
num = 1

@tags.each do |tag|

	# if not visited do dfs for it
	unless group_nums[tag.id]
		dfs(tag, num, group_nums)
		num += 1
	end
end


json.nodes @tags do |tag|

  json.extract! tag, :id, :name
  json.group group_nums[tag.id]
end

json.links @edges do |edge|
	
  json.source edge.tag_id - 1
  json.target edge.target_id - 1
  json.edge_type edge.edge_type
  json.id edge.id
  #json.value 1
end

json.edge_types Edge.uniq.pluck(:edge_type) do |edge_type|
	json.name edge_type
	json.num Edge.where(edge_type: edge_type).length
end

