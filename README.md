# ZBX

This project is inspired by the following repos:

- [zabbixapi](https://github.com/vadv/zabbixapi)
- [pyzabbix](https://github.com/lukecyca/pyzabbix).

## Installation

Add this line to your application's Gemfile:

    gem 'zbx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zbx

## Usage

```ruby
require 'zbx'

# the following code are doing the same thing ,that is get a host whose id is 10160

ZBX.client user, password, api_url do
  host.get hostids: 10160
end

ZBX.client user, password, api_url do
  host do
    get hostids: 10160
  end
end



ZBX.client do
  set user: user, password: password
  set api_url: 'http://api_url'
  host.get hostids: 10160
end

client = ZBX.client(user, password, api_url)
client.host.get hostids: 10160

host_api = client.host
host_api.get hostids: 10160
```

```bash
# CLI

# get the name of a host whose id is 10160
> $ zbx send host.get '{"hostids": 10160, "output": ["name"]}'
# output:
# [{"hostid"=>"10160", "name"=>"store03.pf"}]

# open api doc in browser
> $ zbx doc host.get -v 2.0

# help
> $ zbx help
# output:
# Commands:
#   zbx doc [method-name or entity-name]  # Open the api doc in browser, -d its short term
#   zbx help [COMMAND]                    # Describe available commands or one specific command
#   zbx send [method] [data]              # Send api request to zabbix server, -s is its short term
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


