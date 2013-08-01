class Synctv::Client::Resources::Media < Synctv::Client::Resource
  include Synctv::Client::Scopes

  scope :active, lambda {|param| where(:active => ["true","1"].include?(param.to_s.downcase))}
  scope :named_like, lambda {|param| where(:named_like => param)}

  # [GET] https://service_name.synctv.com/api/v2/media/:medium_id/media/clips.json?access_id=...
  def clips; get("media/clips"); end

end
