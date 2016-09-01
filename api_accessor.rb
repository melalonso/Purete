require 'json'
require 'faraday'

class ApiAccessor

  BASE_URI = 'http://informacionpublica.paraguay.gov.py:80/portal-core/rest/api'
  REQ_TOKEN = '4b8f31b6-232e-4f8f-b30c-74870c22bfe1'
  CLIENT_SECRET = '393a02b58927de61c7fea1fed722eff0a45e320c44174bc5f9d8ddb6858bbdc3'

  def initialize
    @conn = Faraday.new(:url => BASE_URI) do |faraday|
      #faraday.request :url_encoded # form-encode POST params
      #faraday.response :logger                  # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      faraday.headers['Authorization'] = 'Bearer [991f6eb5-7b0a-45f1-9828-bc738fa491c5]'
    end
  end

  def authenticate
    @conn.post do |req|
      req.url '/auth/token'
      req.headers['Authorization'] = "Basic [#{REQ_TOKEN}]"
      req.headers['Content-Type'] = 'application/json'
      req.body = "{ 'clientSecret': #{CLIENT_SECRET} }"
    end
  end

  def get_bodies(id = nil)
    if id
      return @conn.get "instituciones/#{id}"
    end
    @conn.get 'instituciones', {:page => '1'}
  end

  def get_request(id = nil)
    if id
      @conn.get "solicitudes/#{id}"
    end
    @conn.get 'solicitudes', {:page => '1'}
  end

  # Lack of test
  def post_request(request)
    # post payload as JSON instead of "www-form-urlencoded" encoding:
    @conn.post do |req|
      req.url 'solicitudes'
      req.headers['Content-Type'] = 'application/json'
      req.body = '{ "name": "Unagi" }'
    end
  end

end