module ZBX
  class API
    # username, password, and zabbix api url
    # if block is given, it will be evaluated in the object
    # that is to say, you can write something like this.
    #
    # ZBX::API.new(user, pass, api_url) do
    #   host.get(hostids: 1)
    # end
    #
    # -- this is equal to the following --
    #
    # ZBX::API.new(user, pass, api_url).host.get(hostids: 1)

    def initialize user=nil, pass=nil, url=nil, &b
      @auth = nil
      @user, @pass, @http = user, pass, HttpClient.new(url)

      instance_eval(&b) if block_given?
    end

    def set option={}
      @user, @auth = option[:username], nil if option[:username]
      @pass, @auth = option[:password], nil if option[:password]
      @http.api_url = option[:api_url] if option[:api_url]
    end

    def request method, params={}
      # in any api request except `user.login`
      # we add the following options:
      #
      # - params[:output] = "extend"
      # - id              = a random id
      # - jsonrpc         = '2.0'
      # - auth            = an authentication token

      params[:output] ||= "extend"
      opts = {method: method,
              params: params,
              id: _id,
              jsonrpc: '2.0'}
      opts[:auth] = auth! unless method == 'user.login'
      @http.request opts
    end

    def auth!
      @auth ||= user.login user: @user, password: @pass
    end

    def method_missing m, &b
      Entity.new m, self, &b
    end

    private

    def _id
      rand(100000)
    end
  end
end
