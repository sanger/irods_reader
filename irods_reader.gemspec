# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'irods_reader/version'

Gem::Specification.new do |gem|
  gem.name          = "irods_reader"
  gem.version       = IrodsReader::VERSION
  gem.authors       = ["James Glover"]
  gem.email         = ["jg16@sanger.ac.uk"]
  gem.description   = %q{Provides an easy interface for interacting with the iRods service}
  gem.summary       = %q{
    Provides a ruby interface for search and retrieval of files from an iRods database.
    It acts as a simple wrapper for the command line interface, and is written primarily
    for interacting with the implementation used at the Sanger.

    This gem is not fully-featured, and is a minimal implementation to meet the requirements
    of the Sequencescape project.
  }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rake','~>0.9.2.2')
  gem.add_development_dependency('rspec','~>2.11.0')
end
