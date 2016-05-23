# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_shipping_postnl'
  s.version     = '3.1.0'
  s.summary     = 'Spree shipping calculator for PostNL'
  s.description = 'This gem provides a basic shipping calculator for PostNL packages and letters to be send within the Netherlands'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Sjors Baltus'
  s.email     = 'spree_gems@sjorsbaltus.nl'
  s.homepage  = 'http://www.sjorsbaltus.nl'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0.rc1'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.7'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
