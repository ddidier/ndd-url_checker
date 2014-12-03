source 'http://rubygems.org'

HOST_OS = RbConfig::CONFIG['host_os']


# ------------------------------------------------------------------------------
# Dependencies required to use the gem.



# ------------------------------------------------------------------------------
# Dependencies to develop the gem.
# Everything needed to run rake, tests, features, etc.
group :development do

  gem 'bundler',                    '~> 1.7.0',  require: false
  gem 'guard',                      '~> 2.8.0',  require: false
  gem 'guard-bundler',              '~> 2.0.0',  require: false
  gem 'guard-rspec',                '~> 4.3.0',  require: false
  gem 'guard-spork',                '~> 2.0.0',  require: false
  gem 'jeweler',                    '~> 2.0.0',  require: false
  gem 'rdoc',                       '~> 4.1.0',  require: false
  gem 'rspec',                      '~> 3.1.0',  require: false
  gem 'rspec-collection_matchers',  '~> 1.1.0',  require: false
  gem 'simplecov',                  '~> 0.9.0',  require: false
  gem 'spork',                      '~> 0.9.0',  require: false
  gem 'webmock',                    '~> 1.20.0', require: false

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
