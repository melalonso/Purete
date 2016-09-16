require './api_accessor'
require './utils/request_parser'

# QueremoSaber just requires title, description, name, email.



# req_parser = RequestParser.new(person, pb, rq_info)
# request = req_parser.parse
# puts JSON.pretty_generate(request)


puts 'Starting ...'
api = ApiAccessor.new

response = api.get_supports
json_res = JSON.parse(response.body)
puts JSON.pretty_generate(json_res)
