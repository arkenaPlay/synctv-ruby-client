class Synctv::Client::Resources::Key < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.prefix = "/api/v2/dash_manifests/:dash_manifest_id/"
end