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

ZBX::API.new username, password, api_url do
  host.get hostids: 10160
end

ZBX::API.new username, password, api_url do
  host do
    get hostids: 10160
  end
end

ZBX::API.new(username, password, api_url).host.get hostids: 10160

ZBX::API.new do
  set username: 'username', password: password
  set api_url: 'http://api_url'
  host.get hostids: 10160
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
