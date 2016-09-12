require 'json'
require 'faraday'
require 'yaml'

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

  def read_config(env = 'test')
    config = YAML.load_file('config/gov_api.yml')
    @base_uri = config[env]['uri']
    @req_token = config[env]['request_token']
    @client_secret = config[env]['client_secret']
  end

  def get_bodies(id = nil)
    check_expiry
    if id
      return @conn.get "instituciones/#{id}"
    end
    @conn.get 'instituciones', {:page => '1'}
  end

  def get_request(id = nil)
    check_expiry
    if id
      return @conn.get "solicitudes/#{id}"
    end
    @conn.get 'solicitudes', {:page => '1'}
  end

  def get_supports
    check_expiry
    @conn.get 'soportes'
  end

  def post_request(request_hash)
    check_expiry
    # post payload as JSON instead of "www-form-urlencoded" encoding:
    @conn.post do |req|
      req.url 'solicitudes'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = request_hash.to_json.to_s
    end
  end

  def check_expiry
    if @expiration_date.to_i < Time.now.to_i
      new_access_token
    end
  end

  def new_access_token
    response = authenticate
    map = JSON.parse(response.body)
    @expiration_date = response.headers['x-rate-limit-reset']
    @conn.headers['Authorization'] = "Bearer [#{map['accessToken']}]"
  end

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