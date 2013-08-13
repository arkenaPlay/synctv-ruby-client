class Synctv::Client::Resources::Accounts::MediaLink < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix = "/api/v2/accounts/"
end
