class Synctv::Client::Resources::Mp4 < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.element_name = "mp4_encode"
  self.prefix       = "/api/v2/media/:medium_id/"
end