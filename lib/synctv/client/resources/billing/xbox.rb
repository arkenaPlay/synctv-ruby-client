class Synctv::Client::Resources::Billing::Xbox < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix = "/api/v2/billing/"
end
