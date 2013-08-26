require "zbx/version"
require 'zbx/entity'
require 'zbx/http_client'
require 'zbx/api'

require 'json'
require 'net/http'

module ZBX
  def self.client user, password, api_url, &block
    API.new user, password, api_url, &block
  end
end
