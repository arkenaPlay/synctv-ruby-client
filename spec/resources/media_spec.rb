require "spec_helper"

describe Synctv::Client::Resources::Media do
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
  
  it "should find" do
    media = Synctv::Client::Resources::Media.find(1)
    media.id.should   == 1
    media.name.should == "Matz"
  end
end
