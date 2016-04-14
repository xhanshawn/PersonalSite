json.array!(@tags) do |tag|
  json.extract! tag, :id, :post_id, :name
  json.url tag_url(tag, format: :json)
end
