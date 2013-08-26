require "zbx/version"
require 'zbx/entity'
require 'zbx/http_client'
require 'zbx/api'

require 'json'
require 'net/http'

module ZBX
  class << self
    # zbx module API, user should call this method to initialize a
    # zabbxi-api client.
    def client user=nil, password=nil, api_url=nil, &block
      API.new(user || configuration.user,
              password || configuration.password,
              api_url || configuration.api_url,
              &block)
    end

    # configuration
    def config
      yield(configuration)
      configuration
    end

    def reset_configuration!
      @configuration = nil
    end

    private

    def configuration
      @configuration ||= Struct.new(:user, :password, :api_url) {
        def [] option
          __send__ option
        end
      }.new
    end
  end
end
