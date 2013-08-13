class Synctv::Client::Resources::Media::View < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix       = "/api/v2/media/"
end