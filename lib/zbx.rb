require "zbx/version"
require 'zbx/entity'
require 'zbx/http_client'
require 'zbx/api'

require 'json'
require 'net/http'

module ZBX
  def self.client user=nil, password=nil, api_url=nil, &block
    API.new user, password, api_url, &block
  end
end
