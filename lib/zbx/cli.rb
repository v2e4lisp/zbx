require 'yaml'
require 'thor'

module ZBX
  module CLI
    module Helper
      extend self
      def browse link
        case RbConfig::CONFIG['host_os']
        when /mswin|mingw|cygwin/
          system "start #{link}"
        when /darwin/
          system "open #{link}"
        when /linux|bsd/
          system "xdg-open #{link}"
        end
      end
    end

    class CLI < Thor
      map "-s" => :send
      map "-d" => :doc

      # ---------------------------- send ------------------------------

      desc "send [method] [data]", "Send api request to zabbix server, -d is its short term"
      long_desc <<-LLL
      Example:
      \x5> $ zbx send host.get '{"hostids": 321}'

      > $ zbx -s host.get '{"hostids": 321}'

      # specify user name and password
      \x5> $ zbx -s host.get '{"hostids": 321}' -u me -p mypassword
      LLL

      method_option :user, type: :string, aliases: '-u', desc: "zabbix username, default defined in ~/.zbxconfig"
      method_option :password, type: :string, aliases: '-p', desc: "zabbix password, default defined in ~/.zbxconfig"
      method_option :api_url, type: :string, aliases: '-l',  desc: "zabbix api url, default defined in ~/.zbxconfig"

      def send(method, data='{}')
        config_file = File.expand_path('~/.zbxconfig')
        default = File.exists?(config_file) ? YAML.load_file(config_file) : {}

        say (options[:user] || default["user"])
        say (options[:password] || default["password"])
        client = ZBX::API.new(options[:user] || default["user"],
                              options[:password] || default["password"],
                              options[:api_url] || default["api_url"])
        # x = method.split('.')
        client.request method, JSON.parse(data)
        # say client.send(x.first).send(x.last, JSON.parse(data))
      end


      # ---------------------------- doc ------------------------------

      desc "doc [method-name or entity-name]", "Open the api doc in browser, -d its short term"
      long_desc <<-LLL
      Example:
      \x5> $ zbx doc host.get

      > $ zbx -d host

      > $ zbx doc hostgroup -v 1.8
      LLL
      method_option :version, default: 2.0, aliases: "-v", type: :numeric, desc: "api version, config it in ~/.zbxconfig"

      def doc method=''
        version = options[:version]
        base = "https://www.zabbix.com/documentation/#{version}/"
        suffix = case version
                 when 1.8
                   'api/'
                 when 2.0
                   'manual/appendix/api/'
                 when 2.2
                   'manual/api/reference/'
                 end
        url = base << suffix << method.gsub('.', '/')
        say "browse #{url}"
        Helper.browse url
      end
    end

  end
end
