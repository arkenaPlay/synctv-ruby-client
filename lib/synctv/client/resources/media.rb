class Synctv::Client::Resources::Media < Synctv::Client::Resource
  include Synctv::Client::Scopes

  scope :active, lambda {|param| where(:active => ["true","1"].include?(param.to_s.downcase))}
  scope :named_like, lambda {|param| where(:named_like => param)}

end
