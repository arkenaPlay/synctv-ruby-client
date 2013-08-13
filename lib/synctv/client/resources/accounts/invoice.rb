class Synctv::Client::Resources::Accounts::Invoice < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix = "/api/v2/accounts/"
end
