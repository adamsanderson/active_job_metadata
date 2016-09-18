# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job_metadata/version'

Gem::Specification.new do |spec|
  spec.name          = "active_job_metadata"
  spec.version       = ActiveJobMetadata::VERSION
  spec.authors       = ["adam sanderson"]
  spec.email         = ["netghost@gmail.com"]

  spec.summary       = "Store status and metadata for ActiveJobs"
  spec.description   = "Store metadata such as job status, percent complete, etc. for ActiveJobs"
  spec.homepage      = "https://github.com/adamsanderson/activejob_metadata"
  
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "activejob",      ">= 4.2", "< 5.1"
  spec.add_dependency "activesupport",  ">= 4.2", "< 5.1"
  
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "minitest", "~> 5.9"
end
