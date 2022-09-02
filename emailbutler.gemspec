# frozen_string_literal: true

require_relative 'lib/emailbutler/version'

Gem::Specification.new do |spec|
  spec.name        = 'emailbutler'
  spec.version     = Emailbutler::VERSION
  spec.authors     = ['Bogdanov Anton']
  spec.email       = ['kortirso@gmail.com']
  spec.homepage    = 'https://github.com/kortirso/emailbutler'
  spec.summary     = 'Write a short summary, because RubyGems requires one.'
  spec.description = 'Write a longer description or delete this line.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.7'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/kortirso/emailbutler/blob/master/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '> 6.0.0'
  spec.add_dependency 'sprockets-rails', '> 3.4.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pg', '> 1.0'
  spec.add_development_dependency 'puma', '> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.3'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
end
