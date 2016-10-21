require './services/api_accessor'
require './services/request_parser'

# QueremoSaber just requires title, description, name, email.

# RequestController

request = RequestParser.parse(@info_request, @outgoing_message)

api = ApiAccessor.new
response = api.post_request(request)
req_json = JSON.parse(response.body)
@info_request.id_gov = req_json['id'].to_i
@info_request.save!

# RequestController end


# RequestMailer

api = ApiAccessor.new
request_id = reply_info_request.id_gov.to_i
req_flow_response = api.get_request_flow request_id
req_flows = JSON.parse(req_flow_response.body)

# Not sure if needed, but consulted Gaby and
# she told that the results are not ordered.
# So to prevent its better to sort
req_flows.sort_by! { |hash| hash['id'] }
most_recent = req_flows[ req_flows.size - 1 ]

new_mail = Mail.new do
  to      'queremosaber@queremosaber.org.py'
  from    'API'
  subject 'Respuesta de la solicitud de informacion'
  body most_recent['comentario']
end

raw_email = new_mail.to_s

# RequestMailer end