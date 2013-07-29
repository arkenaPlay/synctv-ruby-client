class Synctv::Client::Resources::OwnershipPolicy::ViewRule < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.prefix = "/api/v2/ownership_policies/"
end
