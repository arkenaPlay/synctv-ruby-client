class Synctv::Client::Resources::Account < Synctv::Client::Resource
  include Synctv::Client::Scopes
  
  scope :by_email, lambda {|param| where(:by_email => param)}
  scope :with_role, lambda {|param| where(:with_role => param)}
  scope :key, lambda {|param| where(:key => param)}
  scope :value, lambda {|param| where(:value => param)}
  scope :any_of_account_type_ids, lambda {|params| where(:any_of_account_type_ids => [params].flatten)}
  scope :none_of_account_type_ids, lambda {|params| where(:none_of_account_type_ids => [params].flatten)}
end
