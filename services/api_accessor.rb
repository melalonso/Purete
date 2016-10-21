require 'json'
require 'faraday'
require 'yaml'

# Accessor for the Government's API that
# allows the GET and POST methods.
class ApiAccessor

  def initialize
    read_config
    @conn = Faraday.new(:url => @base_uri) do |faraday|
      # faraday.request :url_encoded # form-encode POST params
      # faraday.response :logger                  # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    new_access_token
  end

  # Reads the configuration of the environment to use.
  # Params:
  # +env+:: environment to use. Default is testing
  def read_config(env = 'production')
    config = YAML.load_file('config/gov_api.yml')
    @base_uri = config[env]['uri']
    @req_token = config[env]['request_token']
    @client_secret = config[env]['client_secret']
  end

  # Gets the information of a public body.
  # Params:
  # +id+:: id to obtain a single public body, none to get all.
  def get_bodies(id = nil, page = '1')
    check_expiry
    if id
      return @conn.get "instituciones/#{id}"
    end
    @conn.get 'instituciones', {:page => page}
  end

  # Gets the information of a request.
  # Params:
  # +id+:: id to obtain a single request, none to get all.
  def get_request(id = nil)
    check_expiry
    if id
      return @conn.get "solicitudes/#{id}"
    end
    @conn.get 'solicitudes', {:page => '1'}
  end

  # Gets the information of the flows of a request.
  # Params:
  # +id+:: id to obtain the flows of a request
  def get_request_flow(id)
    check_expiry
    @conn.get "flujos-solicitud/#{id}"
  end

  # Gets the information of the supports.
  def get_supports
    check_expiry
    @conn.get 'soportes'
  end

  # Posts the information of a request.
  # Params:
  # +request+:: hash with the request's information to post.
  def post_request(request_hash)
    check_expiry
    @conn.post do |req|
      req.url 'solicitudes'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = request_hash.to_json.to_s
    end
  end

  # Method to check whether is needed to get a new access token
  def check_expiry
    if @expiration_date.to_i < Time.now.to_i
      new_access_token
    end
  end

  # Gets a new access token and sets it in the connection's headers
  def new_access_token
    response = authenticate
    map = JSON.parse(response.body)
    @expiration_date = response.headers['x-rate-limit-reset']
    @conn.headers['Authorization'] = "Bearer [#{map['accessToken']}]"
  end

  # Uses the API to authenticate using the request token and client secret
  def authenticate
    @conn.post do |req|
      req.url 'auth/token'
      req.headers['Authorization'] = "Basic [#{@req_token}]"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = "{ \"clientSecret\": \"#{@client_secret}\" }"
    end
  end

  private :check_expiry, :new_access_token, :authenticate

end