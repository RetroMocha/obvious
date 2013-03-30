# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obvious/version'

Gem::Specification.new do |gem|
  gem.name          = "obvious"
  gem.version       = Obvious::VERSION
  gem.authors       = ["Brian Knapp"]
  gem.email         = ["brianknapp@gmail.com"]
  gem.description   = "A set of tools to build apps using the Obvious Architecture"
  gem.summary       = "Isn't it Obvious?"
  gem.homepage      = "http://obvious.retromocha.com/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end
