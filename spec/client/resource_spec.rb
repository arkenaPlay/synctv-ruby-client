require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class StaticSettingsTestResource < Synctv::Client::Resource
  self.site             = "http://localhost:5000"
  self.client_key       = "xpDEo1zNiqxGsrGHrzzBAC5ZFveYmHHped1RFK6Vtz8r"
  self.device_uid       = "my_device_uid"
  self.account_email    = "test@synctv.com"
  self.account_password = "xdf432gGT!"
end

class DynamicSettingsTestResource < Synctv::Client::Resource
end

describe "Client::Resource" do
  
  describe "dynamic configuration" do
  
    it "should set and get client_key" do
      DynamicSettingsTestResource.client_key = "abcdefg"
      DynamicSettingsTestResource.client_key.should == "abcdefg"
    end
    
  end
end
