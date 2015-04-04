# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'power_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "power_converter"
  spec.version       = PowerConverter::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]
  spec.summary       = %q{A lightweight library to define object conversion methods/modules.}
  spec.description   = %q{A lightweight library to define object conversion methods/modules.}
  spec.homepage      = "https://github.com/jeremyf/power_converter"
  spec.license       = "APACHE2"

  spec.files         = `git ls-files -z -- lib/* bin/* LICENSE README.md CHANGELOG.md power_converter.gemspec`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "rubocop", "~> 0.2"
  spec.add_development_dependency "simplecov", "~> 0.9"
end
