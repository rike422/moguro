# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moguro/version'

Gem::Specification.new do |spec|
  spec.name    = 'moguro'
  spec.version = Moguro::VERSION
  spec.authors = ['Akira Takahashi']
  spec.email   = ['rike422@gmail.com']

  spec.summary     = 'Decorator style assertions and type check library for Contract programming.'
  spec.description = 'Decorator style assertions and type check library for Contract programming.'
  spec.homepage    = 'https://github.com/rike422/moguro'
  spec.license     = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'method_source'
  spec.add_dependency 'parser'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-power_assert'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'test-unit-full'
  spec.add_development_dependency 'yard'
end
