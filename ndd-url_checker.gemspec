require File.expand_path('lib/ndd/url_checker/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'ndd-url_checker'
  s.version = NDD::UrlChecker::VERSION
  s.author = 'David DIDIER'
  s.email = 'c_inconnu2@yahoo.fr'

  s.summary = %q{Validate URLs}
  s.description = %q{Validate URLs}
  s.homepage = 'https://github.com/ddidier/ndd-url_checker'
  s.license = 'MIT'

  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.files = Dir['bin/*', '{lib}/**/*.rb', 'CHANGELOG.md', 'LICENSE.txt', 'README.md']

  s.required_ruby_version = ['>= 2.0.0', '< 2.4']

  s.add_runtime_dependency 'cod', '~> 0.6'
  s.add_runtime_dependency 'logging', '~> 1.8'

  s.extra_rdoc_files = %w(LICENSE.txt README.md)

end
