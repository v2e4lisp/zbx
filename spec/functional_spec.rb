require 'spec_helper'

describe ZBX::API do
  info = YAML.load_file(File.expand_path('~/.zbxconfig'))
  user, password, api_url = info["user"], info["password"], info["api_url"]

  before(:each) do
    @client = ZBX::API.new user, password, api_url
  end

  describe "Using host.get to check if api request works " do
    it "should return an not-empty array" do
      ret = @client.host.get hostids: 10163
      ret.should be_an(Array)
      ret.first["hostid"].should eq("10163")
    end

    it "should return an empty array" do
      ret = @client.host.get hostids: 1111111
      ret.should be_an(Array)
      ret.should be_empty
    end
  end

  describe "Overwriting the default param `output`" do
    it "should works and the returned host object has only hostid" do
      ret = @client.host.get hostids: 10163, output: "hostid"
      ret.first.size.should eq(1)
      ret.first.should have_key("hostid")
    end

    it "should works and the returned host objectt has only hostid and host" do
      ret = @client.host.get hostids: 10163, output: ["hostid", "host"]
      ret.first.size.should eq(2)
      ret.first.should have_key("hostid")
      ret.first.should have_key("host")
    end
  end
end
