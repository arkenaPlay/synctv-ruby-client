class Synctv::Client::Resources::Encodes::Mp4 < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.element_name = "mp4_encode"
  self.prefix       = "/api/v2/ingest_videos/:ingest_video_id/"
end