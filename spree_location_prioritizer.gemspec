# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_location_prioritizer'
  s.version     = '3.4.0'
  s.summary     = 'sort the packages with stock location priority settings'
  s.description = 'for multi-warehouse stores, we need set the closest/cheapest stock location for the shipment. this extension will do it with stock location settings.'
  s.required_ruby_version = '>= 1.2.2'

  s.author    = 'Albert Liu'
  s.email     = 'albertliu@naturalwellbeing.com'
  s.homepage  = 'http://www.naturalwellbeing.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  version = '~> 3-4-stable'
  #s.add_dependency 'spree_core'


end
