class Synctv::Client::Resources::Encodes::Smooth < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.element_name = "smooth_manifest"
  self.prefix       = "/api/v2/ingest_videos/:ingest_video_id/"
end