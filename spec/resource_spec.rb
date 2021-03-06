require "spec_helper"

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

    it "should set and get device_uid" do
      DynamicSettingsTestResource.device_uid = "123456789"
      DynamicSettingsTestResource.device_uid.should == "123456789"
    end

    it "should set and get account_email" do
      DynamicSettingsTestResource.account_email = "test@example.com"
      DynamicSettingsTestResource.account_email.should == "test@example.com"
    end

    it "should set and get account_password" do
      DynamicSettingsTestResource.account_password = "tr3n3ty"
      DynamicSettingsTestResource.account_password.should == "tr3n3ty"
    end
    
  end
  
  describe "resource behavior" do
    before(:each) do
      Synctv::Client::Resource.site = "http://test.sample.com:5000"
      @media  = { :id => 1, :name => "Matz" }.to_json
      ActiveResource::HttpMock.respond_to do |mock|
        mock.post   "/api/v2/media.json",   {}, @media, 201, "Location" => "/media/1.json"
        mock.get    "/api/v2/media/1.json", {}, @media
        mock.put    "/api/v2/media/1.json", {}, nil, 204
        mock.delete "/api/v2/media/1.json", {}, nil, 200
      end
    end
    
    describe "dirty" do
      it "should register changes" do
        media = Synctv::Client::Resources::Media.find(1)
        media.name = "Foo"
        media.name.should == "Foo"
        media.should be_changed
        media.changes.should == {"name"=>["Matz", "Foo"]} 
      end
      
      it "should not register changes for unkown attributes" do
        media = Synctv::Client::Resources::Media.find(1)
        media.description = "Test Description"
        media.should_not be_changed
        media.changes.should == {} 
        media.description.should == "Test Description"
      end
      
    end
  end
end
