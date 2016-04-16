json.name "root"
json.children @tags do |tag|
  json.extract! tag, :name, :id
  json.size tag.posts.length + 1
end
