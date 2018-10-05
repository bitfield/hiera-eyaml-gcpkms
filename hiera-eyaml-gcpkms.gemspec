# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiera/backend/eyaml/encryptors/gcpkms/version'

Gem::Specification.new do |gem|
  gem.name          = "hiera-eyaml-gcpkms"
  gem.version       = Hiera::Backend::Eyaml::Encryptors::GcpKms::VERSION
  gem.description   = "GCP KMS encryptor for use with hiera-eyaml"
  gem.summary       = "Encryption plugin for hiera-eyaml backend for Hiera"
  gem.author        = "John Arundel"
  gem.license       = "MIT"

  gem.homepage      = "http://github.com/bitfield/hiera-eyaml-gcpkms"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('hiera-eyaml', '>=1.3.8')
end
