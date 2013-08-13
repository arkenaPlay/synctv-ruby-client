class Synctv::Client::Resources::Manifests::Dash < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.prefix       = "/api/v2/media/:medium_id/"
  self.element_name = "dash_manifest"
end