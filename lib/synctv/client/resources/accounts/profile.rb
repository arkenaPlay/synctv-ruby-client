class Synctv::Client::Resources::Accounts::Profile < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix = "/api/v2/accounts/"
end
