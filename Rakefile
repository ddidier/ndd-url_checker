require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/ndd/url_checker/version'

task :default => :spec


RSpec::Core::RakeTask.new(:spec)

desc 'Generate code coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end
