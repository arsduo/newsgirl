# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newsgirl/version'

Gem::Specification.new do |gem|
  gem.name          = "newsgirl"
  gem.version       = Newsgirl::VERSION
  gem.authors       = ["Alex Koppel"]
  gem.email         = ["alext@alexkoppel.com"]
  gem.description   = "A pull-request-based changelog generator"
  gem.summary       = "Generate changelogs from pull requests"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
