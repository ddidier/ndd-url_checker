source 'http://rubygems.org'


# Dependencies required to use the gem. This will automatically pull in this
# gem and all its dependencies specified in the gemspec.
gem 'ndd-url_checker', path: File.expand_path(__dir__)


# ------------------------------------------------------------------------------
# Dependencies to develop the gem.
# Everything needed to run rake, tests, features, etc.
group :development do

  gem 'bundler',                    '~> 1.7',  require: false
  gem 'guard',                      '~> 2.14', require: false
  gem 'guard-bundler',              '~> 2.0',  require: false
  gem 'guard-rspec',                '~> 4.7',  require: false
  gem 'guard-spork',                '~> 2.0',  require: false
  gem 'rdoc',                       '~> 4.1',  require: false
  gem 'rake',                       '~> 11.3', require: false
  gem 'rspec',                      '~> 3.5',  require: false
  gem 'rspec-collection_matchers',  '~> 1.1',  require: false
  gem 'simplecov',                  '~> 0.12', require: false
  gem 'spork',                      '~> 0.9',  require: false
  gem 'webmock',                    '~> 2.1',  require: false
  gem 'yard',                       '~> 0.9',  require: false

  HOST_OS = RbConfig::CONFIG['host_os']

  case HOST_OS
  when /darwin/i
      gem 'growl'
      gem 'rb-fsevent'
    when /linux/i
      gem 'libnotify'
      gem 'rb-inotify'
    when /mswin|windows/i
      gem 'rb-fchange'
      gem 'rb-notifu'
      gem 'win32console'
    else
      raise "Platform '#{HOST_OS}' is not supported"
  end

end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.4', require: false
end
