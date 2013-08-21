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

    def initialize user, pass, url, &b
      @auth = nil
      @user = user
      @pass = pass
      @uri = URI.parse(url)

      @http ||= Net::HTTP.new @uri.host, @uri.port
      if @uri.port == 443
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      instance_eval(&b) if block_given?
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
      _request(method: method,
               params: params,
               auth: auth!,
               id: _id, jsonrpc: '2.0')
    end

    def auth!
      @auth ||= _request(method: "user.login",
                         params: {user: @user, password: @pass},
                         id: _id,
                         jsonrpc: '2.0')

      # if login failed, we raise an auth error !
      @auth or raise "Authentication failed"
    end

    def method_missing m, &b
      Entity.new m, self, &b
    end

    private

    def _request options={}
      # send post request
      req = Net::HTTP::Post.new @uri.request_uri
      req.add_field('Content-Type', 'application/json-rpc')
      req.body = options.to_json
      JSON.parse(@http.request(req).body)['result']
    rescue
      nil
    end

    def _id
      rand(100000)
    end
  end
end
