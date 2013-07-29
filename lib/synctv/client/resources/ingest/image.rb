class Synctv::Client::Resources::Ingest::Image < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  # attr_accessor :medium_id
  
  self.element_name = "ingest_image"
  self.prefix       = "/api/v2/media/:medium_id/"

  def prefix_options
    {:medium_id => medium_id}
  end
  
  def medium_id
    @prefix_options[:medium_id] if @prefix_options.is_a?(Hash)
  end
  
end
