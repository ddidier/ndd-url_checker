# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: ndd-url_checker 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ndd-url_checker"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David DIDIER"]
  s.date = "2015-11-26"
  s.description = "Validate URLs"
  s.email = "c_inconnu2@yahoo.fr"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".ruby-gemset",
    ".ruby-version",
    ".travis.yml",
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/ndd/url_checker.rb",
    "lib/ndd/url_checker/abstract_url_checker.rb",
    "lib/ndd/url_checker/blocking_url_checker.rb",
    "lib/ndd/url_checker/forked_url_checker.rb",
    "lib/ndd/url_checker/parallel_url_checker.rb",
    "lib/ndd/url_checker/reporting_url_checker.csv.erb",
    "lib/ndd/url_checker/reporting_url_checker.html.erb",
    "lib/ndd/url_checker/reporting_url_checker.json.erb",
    "lib/ndd/url_checker/reporting_url_checker.rb",
    "lib/ndd/url_checker/status.rb",
    "lib/ndd/url_checker/status_decorator.rb",
    "lib/ndd/url_checker/threaded_url_checker.rb",
    "ndd-url_checker.gemspec",
    "spec/ndd/url_checker/abstract_url_checker_spec.rb",
    "spec/ndd/url_checker/blocking_url_checker_spec.rb",
    "spec/ndd/url_checker/forked_url_checker_spec.rb",
    "spec/ndd/url_checker/parallel_url_checker_spec.rb",
    "spec/ndd/url_checker/reporting_url_checker/custom.txt.erb",
    "spec/ndd/url_checker/reporting_url_checker/multiple_urls.csv",
    "spec/ndd/url_checker/reporting_url_checker/multiple_urls.html",
    "spec/ndd/url_checker/reporting_url_checker/multiple_urls.json",
    "spec/ndd/url_checker/reporting_url_checker/multiple_urls.txt",
    "spec/ndd/url_checker/reporting_url_checker/single_url.csv",
    "spec/ndd/url_checker/reporting_url_checker/single_url.html",
    "spec/ndd/url_checker/reporting_url_checker/single_url.json",
    "spec/ndd/url_checker/reporting_url_checker/single_url.txt",
    "spec/ndd/url_checker/reporting_url_checker_spec.rb",
    "spec/ndd/url_checker/status_decorator_spec.rb",
    "spec/ndd/url_checker/status_spec.rb",
    "spec/ndd/url_checker/threaded_url_checker_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/multiple_url_checker_spec.rb",
    "spec/support/single_url_checker_spec.rb"
  ]
  s.homepage = "http://github.com/ddidier/ndd-url_checker"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Validate URLs"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cod>, ["~> 0.6"])
      s.add_runtime_dependency(%q<logging>, ["~> 1.8"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<guard>, ["~> 2.13"])
      s.add_development_dependency(%q<guard-bundler>, ["~> 2.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.6"])
      s.add_development_dependency(%q<guard-spork>, ["~> 2.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.3"])
      s.add_development_dependency(%q<rspec-collection_matchers>, ["~> 1.1"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_development_dependency(%q<spork>, ["~> 0.9"])
      s.add_development_dependency(%q<webmock>, ["~> 1.20"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<libnotify>, [">= 0"])
      s.add_development_dependency(%q<rb-inotify>, [">= 0"])
    else
      s.add_dependency(%q<cod>, ["~> 0.6"])
      s.add_dependency(%q<logging>, ["~> 1.8"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<guard>, ["~> 2.13"])
      s.add_dependency(%q<guard-bundler>, ["~> 2.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.6"])
      s.add_dependency(%q<guard-spork>, ["~> 2.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.1"])
      s.add_dependency(%q<rspec>, ["~> 3.3"])
      s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.1"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_dependency(%q<spork>, ["~> 0.9"])
      s.add_dependency(%q<webmock>, ["~> 1.20"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<libnotify>, [">= 0"])
      s.add_dependency(%q<rb-inotify>, [">= 0"])
    end
  else
    s.add_dependency(%q<cod>, ["~> 0.6"])
    s.add_dependency(%q<logging>, ["~> 1.8"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<guard>, ["~> 2.13"])
    s.add_dependency(%q<guard-bundler>, ["~> 2.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.6"])
    s.add_dependency(%q<guard-spork>, ["~> 2.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.1"])
    s.add_dependency(%q<rspec>, ["~> 3.3"])
    s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.1"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
    s.add_dependency(%q<spork>, ["~> 0.9"])
    s.add_dependency(%q<webmock>, ["~> 1.20"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<libnotify>, [">= 0"])
    s.add_dependency(%q<rb-inotify>, [">= 0"])
  end
end

