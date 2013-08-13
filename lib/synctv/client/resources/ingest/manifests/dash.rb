class Synctv::Client::Resources::Manifests::Dash < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.element_name = "dash_manifest"
  self.prefix       = "/api/v2/ingest_videos/:ingest_video_id/"
end