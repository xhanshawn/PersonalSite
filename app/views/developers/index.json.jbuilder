json.array!(@developers) do |developer|
  json.extract! developer, :id, :name, :introduction, :education
  json.url developer_url(developer, format: :json)
end
