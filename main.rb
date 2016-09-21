require './api_accessor'
require './utils/request_parser'

# QueremoSaber just requires title, description, name, email.

puts 'Starting ...'
api = ApiAccessor.new

response = api.get_bodies(18)
json_res = JSON.parse(response.body)
puts JSON.pretty_generate(json_res)

=begin
9.times do |i|
  response = api.get_bodies(nil, i+1)
  json_res = JSON.parse(response.body)
  puts JSON.pretty_generate(json_res)
end
=end
