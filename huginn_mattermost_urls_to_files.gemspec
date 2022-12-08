# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_mattermost_urls_to_files"
  spec.version       = '0.1'
  spec.authors       = ["Paul"]
  spec.email         = ["git@paul.sx"]

  spec.summary       = %q{Huginn agent that takes a url or url array and attaches the file to mattermost.}
  spec.description   = %q{This Huginn Agent takes a url or array of urls, downloads them, and posts them in mattermost as files.}

  spec.homepage      = "https://github.com/paul-sx/huginn_mattermost_urls_to_files"

  spec.license       = "MIT"


  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "huginn_agent"
  spec.add_runtime_dependency "globalid", "~> 1.0"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "tempfile"
  spec.add_runtime_dependency 'uri'
end
