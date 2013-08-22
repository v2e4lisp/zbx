require 'spec_helper'

describe ZBX::API do
  api_url = 'http://localhost/api_jsonrpc.php'
  before(:each) do
    @invalid_client = ZBX::API.new "fakeusername", "fakepassword", api_url
    @valid_client = ZBX::API.new "wenjun.yan", "123456", api_url
  end

  describe "invalid client authentication" do
    it "should raise a runtime error!" do
      expect { @invalid_client.auth! }.to raise_error(RuntimeError, /Authentication/)
    end
  end

  describe "valid client authentication" do
    it "should not raise any error" do
      expect { @valid_client.auth! }.to_not raise_error
    end

    it "should return a authentication token, which is a string" do
      token = @valid_client.auth!
      token.should be_an(String)
    end
  end
end
