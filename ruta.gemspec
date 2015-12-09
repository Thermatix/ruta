# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruta/version'

Gem::Specification.new do |spec|
  spec.name          = "ruta"
  spec.version       = Ruta::VERSION
  spec.authors       = ["Martin Becker",'Adam Beynon']
  spec.email         = ["mbeckerwork@gmail.com",'adam.beynon@gmail.com']

  spec.summary       = %q{Front end agnostic router built in opal}
  spec.homepage      = "https://github.com/Thermatix/ruta"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "opal", "~> 0.8"
  spec.add_runtime_dependency "opal-browser", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
