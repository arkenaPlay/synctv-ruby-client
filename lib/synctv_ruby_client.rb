require "synctv/client/version"

require "cgi"
require "digest/md5"

require "synctv/client/api_auth"
require "synctv/active_resource/extension"
require "synctv/active_resource/scopes"

require "synctv/client/scopes"
require "synctv/client/resource"

module Synctv::Client::Resources
  module Ingest
  end
end

Dir[File.dirname(__FILE__) + "/synctv/client/resources/*.rb"].each {|file| require file}
Dir[File.dirname(__FILE__) + "/synctv/client/resources/**/*.rb"].each {|file| require file}
