class Synctv::Client::Resources::ImageFormat < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.prefix = "/api/v2/platforms/:platform_id/"
end