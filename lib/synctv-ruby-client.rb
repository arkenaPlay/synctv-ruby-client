require "synctv/client/version"

require "cgi"
require "digest/md5"

require "synctv/client/api_auth"
require "synctv/active_resource/extension"

require "synctv/client/resource"
require "synctv/client/scopes"

Dir[File.dirname(__FILE__) + "/synctv/client/resources/*.rb"].each {|file| require file}