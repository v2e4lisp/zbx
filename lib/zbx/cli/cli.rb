module ZBX
  module CLI
    class CLI < Thor
      include Helpers

      desc "send [method] [data]", "send api request to zabbix server"
      method_option :user, type: :string, aliases: '-u'
      method_option :password, type: :string, aliases: '-p'
      method_option :api_url, type: :string, aliases: '-l'

      def send(method, data='{}')
        config_file = File.expand_path('~/.zbxconfig')
        default = File.exists?(config_file) ? YAML.load_file(config_file).to_hash : {}

        client = ZBX::API.new do
          set username: default["user"]
          set password: default["password"]
          set api_url: default["api_url"]
        end

        x = method.split('.')
        say client.send(x.first).send(x.last, JSON.parse(data))
      end

      desc "doc [method-name or entity-name]", "open the api doc in browser"
      method_option :version, default: 2.0, aliases: "-v", type: :numeric

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
        browse url
      end
    end
  end
end
