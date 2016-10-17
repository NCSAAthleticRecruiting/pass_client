# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pass_client/version'

Gem::Specification.new do |spec|
  spec.name          = "pass_client"
  spec.version       = PassClient::VERSION
  spec.authors       = ["Christian Koch"]
  spec.email         = ["ckoch@ncsasports.org"]

  spec.summary       = %q{A gem to manage connections to the Partner Athlete Search Service (PASS)}
  spec.description   = %q{A gem to manage connections to the Partner Athlete Search Service (PASS)}
  spec.homepage      = "http://gems.ncsasports.org "

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "gems.ncsasports.org "
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "ey-hmac", "2.2.0.ncsa"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency 'geminabox'
end
