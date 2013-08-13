class Synctv::Client::Resources::Manifests::Isp < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.element_name = "isp_manifest"
  self.prefix       = "/api/v2/ingest_videos/:ingest_video_id/"
end