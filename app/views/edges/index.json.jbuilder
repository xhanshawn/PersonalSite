# array to store group num for each tag by id
group_nums = Array.new

# no tag with 0 id
group_nums[0] = 0

# function to do dfs recursively
def dfs(tag, i, group_nums)
	# puts "id:#{tag.id}"
	unless group_nums[tag.id]
		group_nums[tag.id] = i
		tag.edges.each do |e|
			dfs(e.target_tag, i, group_nums) unless group_nums[e.target_tag.id]
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
  json.value 1
end
