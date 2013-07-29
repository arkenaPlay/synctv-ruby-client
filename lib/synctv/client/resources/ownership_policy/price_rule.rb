class Synctv::Client::Resources::OwnershipPolicy::PriceRule < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  self.prefix = "/api/v2/ownership_policies/"
end
