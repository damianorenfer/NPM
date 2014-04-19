json.array!(@computers) do |computer|
  json.extract! computer, :id, :ip_address, :mac_address, :name
  json.url computer_url(computer, format: :json)
end
