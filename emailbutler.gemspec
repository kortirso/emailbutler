# frozen_string_literal: true

require_relative 'lib/emailbutler/version'

Gem::Specification.new do |spec|
  spec.name        = 'emailbutler'
  spec.version     = Emailbutler::VERSION
  spec.authors     = ['Bogdanov Anton']
  spec.email       = ['kortirso@gmail.com']
  spec.homepage    = 'https://github.com/kortirso/emailbutler'
  spec.summary     = 'Email tracker for Ruby on Rails applications.'
  spec.description = 'Emailbutler allows you to track delivery status of emails sent by your app.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.7'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/kortirso/emailbutler/blob/master/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'dry-container', '~> 0.11.0'
  spec.add_dependency 'pagy', '> 4.0'
  spec.add_dependency 'rails', '> 6.0.0'
  spec.add_dependency 'sassc-rails'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pg', '> 1.0'
  spec.add_development_dependency 'puma', '~> 6.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.39'
  spec.add_development_dependency 'rubocop-factory_bot', '~> 2.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rspec_rails', '~> 2.0'
end
