class Synctv::Client::Resources::Billing::CreditCard < Synctv::Client::Resource
  include Synctv::Client::Scopes

  self.prefix = "/api/v2/billing/"
end
