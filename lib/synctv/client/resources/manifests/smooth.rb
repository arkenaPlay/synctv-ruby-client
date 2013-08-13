class Synctv::Client::Resources::Manifests::Smooth < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix       = "/api/v2/media/:medium_id/"
  self.element_name = "smooth_manifest"
end