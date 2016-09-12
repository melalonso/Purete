require './api_accessor'
require './model/person'
require './model/public_body'
require './model/request_info'
require './utils/request_parser'

# QueremoSaber just requires title, description, name, email.

person = Person.new('Bob', 'Castro', 'bobc@gg.com', 1, 'PY',  '2341323233', 'm',
                    '1991-09-09T13:12:49.490Z', 'py')
pb = PublicBody.new(1, 'Min')
rq_info = RequestInfo.new('Prueba3', 'Descripcion', 1, 1, 1)

req_parser = RequestParser.new(person, pb, rq_info)
request = req_parser.parse
# puts JSON.pretty_generate(request)

puts 'Starting ...'
api = ApiAccessor.new
response = api.post_request(request)
json_res = JSON.parse(response.body)
puts JSON.pretty_generate(json_res)