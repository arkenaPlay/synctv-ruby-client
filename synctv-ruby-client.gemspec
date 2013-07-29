# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synctv/client/version'

Gem::Specification.new do |gem|
  gem.name          = "synctv-ruby-client"
  gem.version       = Synctv::Client::VERSION
  gem.authors       = ["Juergen Fesslmeier"]
  gem.email         = ["juergen@synctv.com"]
  gem.description   = %q{Simple access to SyncTV's API.}
  gem.summary       = %q{Full client access to SyncTV's API to use in your gems and Rails apps.}
  gem.homepage      = %q{https://github.com/synctv/synctv-ruby-client}

  gem.add_dependency "activeresource"#, ">= 3.2"

  gem.add_development_dependency "rspec", "~> 2.7.0"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"
#  gem.add_development_dependency "redcarpet"
  gem.add_development_dependency "yard"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end