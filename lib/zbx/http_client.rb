module ZBX
  # HttpClient
  # send http request for api

  class HttpClient
    def initialize api_url=nil
      @api_url = api_url=nil
    end

    def request options={}
      # send post request
      req = Net::HTTP::Post.new uri.request_uri
      req.add_field('Content-Type', 'application/json-rpc')
      req.body = options.to_json
      JSON.parse(http.request(req).body)['result']
    rescue
      nil
    end

    def http
      # Our http client. Borrowed from zabbixapi(https://github.com/vadv/zabbixapi)
      @http ||= Net::HTTP.new uri.host, uri.port
      if uri.port == 443
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      @http
    end

    def uri
      @uri ||= URI.parse(@api_url)
    end

    def api_url= url
      @api_url, @uri, @http = url, nil, nil
      self
    end
  end
end



