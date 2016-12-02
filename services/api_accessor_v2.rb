require 'httparty'
require 'json'
require 'yaml'

class GobiernoParaguay
  include HTTParty
  default_timeout 2

  def initialize(env)
    read_config(env)
    new_access_token
  end

  # Reads the configuration of the environment to use.
  # Params:
  # +env+:: environment to use. Default is testing
  def read_config(env = 'production')
    config = YAML.load_file('config/gov_api.yml')
    self.class.base_uri config[env]['uri']
    @req_token = config[env]['request_token']
    @client_secret = config[env]['client_secret']
  end

  def get_request(id)
    check_expiry
    self.class.get("/solicitudes/#{id}")
  end

  def get_request_flow(id)
    check_expiry
    self.class.get("/flujos-solicitud/#{id}")
  end

  # Method to check whether is needed to get a new access token
  def check_expiry
    if @expiration_date.to_i < Time.now.to_i
      puts "====================================="
      puts "Fue necesario renovar el access token"
      puts "====================================="
      new_access_token
    end
  end

  def check_success(response)
    if response.success?
      response
    else
      raise response.response
    end
  end

  # Gets a new access token and sets it in the connection's headers
  def new_access_token
    response = authenticate
    map = JSON.parse(response.body)
    @expiration_date = response.headers['x-rate-limit-reset']
    self.class.headers['Authorization'] = "Bearer [#{map['accessToken']}]"
  end

  # Uses the API to authenticate using the request token and client secret
  def authenticate
    result = self.class.post('/auth/token',
      :body => { :clientSecret => '393a02b58927de61c7fea1fed722eff0a45e320c44174bc5f9d8ddb6858bbdc3' }.to_json,
      :headers =>
        {
          'Authorization' => "Basic [4b8f31b6-232e-4f8f-b30c-74870c22bfe1]",
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
    )
    result
  end

end
