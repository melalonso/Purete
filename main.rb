require './api_accessor'

# QueremoSaber just requires title, description, name, email.

response = ApiAccessor.new.get_request(1234)
json_res = JSON.parse(response.body)
puts JSON.pretty_generate(json_res)