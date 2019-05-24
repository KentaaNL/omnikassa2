lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omnikassa2/version"

Gem::Specification.new do |spec|
  spec.name          = "omnikassa2"
  spec.version       = Omnikassa2::VERSION
  spec.authors       = ["Aike de Jongste", "Arnout de Mooij", "Luc Zwanenberg"]
  spec.email         = ["luc.zwanenberg@kabisa.nl"]
  spec.license       = "MIT"

  spec.summary       = "Omnikassa2 is a gem for Rabobank's Omnikassa 2.0"
  spec.description   = "Omnikassa2 is a gem for Rabobank's Omnikassa 2.0"
  spec.homepage      = "https://github.com/kabisa/omnikassa2"


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://www.runrails.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  #spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #  f.match(%r{^(test|spec|features)/})
  #end
  spec.files = Dir['{app,config,db,lib}/**/*', 'README.md', 'LICENCE']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
