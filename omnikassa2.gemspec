# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnikassa2/version'

Gem::Specification.new do |spec|
  spec.name          = 'omnikassa2'
  spec.version       = Omnikassa2::VERSION
  spec.authors       = ['Aike de Jongste', 'Arnout de Mooij', 'Luc Zwanenberg', 'Kentaa BV']
  spec.email         = ['support@kentaa.nl']
  spec.license       = 'MIT'

  spec.summary       = "Omnikassa2 is a gem for Rabobank's Omnikassa 2.0"
  spec.description   = "Omnikassa2 is a gem for Rabobank's Omnikassa 2.0"
  spec.homepage      = 'https://github.com/KentaaNL/omnikassa2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'

  spec.add_dependency 'base64'
end
