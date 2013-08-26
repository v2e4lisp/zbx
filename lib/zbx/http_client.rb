module ZBX
  # HttpClient
  # send http request for api

  class HttpClient
    def initialize api_url=nil
      @api_url = api_url
    end

    def request options={}
      # send post request
      req = Net::HTTP::Post.new uri.request_uri
      req.add_field('Content-Type', 'application/json-rpc')
      req.body = options.to_json
      res = http.request(req)

      begin
        parsed = JSON.parse(res.body)
      rescue
        raise "Zabbix API Request Error: \n HTTP Response : #{res.inspect} \n #{res.body}"
      end

      if parsed["error"] or parsed["result"].nil?
        raise "Zabbix API Request Message(Bad request) : #{parsed}"
      end
      parsed['result']
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
    end
  end
end
