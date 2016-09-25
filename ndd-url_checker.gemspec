require File.expand_path('lib/ndd/url_checker/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'ndd-url_checker'
  s.version     = NDD::UrlChecker::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.author      = 'David DIDIER'
  s.email       = 'c_inconnu2@yahoo.fr'
  s.homepage    = 'https://github.com/ddidier/ndd-url_checker'
  s.summary     = 'Validate URLs'
  s.description = 'Validate URLs'
  s.license     = 'MIT'

  s.required_ruby_version = ['>= 2.0.0', '< 2.4']

  s.add_runtime_dependency 'cod',     '~> 0.6'
  s.add_runtime_dependency 'logging', '~> 1.8'

  s.require_path = 'lib'
  s.files        = Dir['bin/*', '{lib}/**/*.rb', 'CHANGELOG.md', 'LICENSE.txt', 'README.md']

  s.extra_rdoc_files = %w(LICENSE.txt README.md)

end
