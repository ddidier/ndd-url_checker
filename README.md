# NDD URL Checker

[![Build Status](https://secure.travis-ci.org/ddidier/ndd-url_checker.png)](http://travis-ci.org/ddidier/ndd-url_checker)
[![Dependency Status](https://gemnasium.com/ddidier/ndd-url_checker.png)](https://gemnasium.com/ddidier/ndd-url_checker)
[![Code Climate](https://codeclimate.com/github/ddidier/ndd-url_checker/badges/gpa.svg)](https://codeclimate.com/github/ddidier/ndd-url_checker)
[![Test Coverage](https://codeclimate.com/github/ddidier/ndd-url_checker/badges/coverage.svg)](https://codeclimate.com/github/ddidier/ndd-url_checker)

An URL validator.

The API documentation can be find at [RubyDoc](http://www.rubydoc.info/github/ddidier/ndd-url_checker).

## Prerequisites

This gem requires Ruby 2.x and is tested with:

- Ruby 2.0.0
- Ruby 2.1.x

## Usage

This gem provides several types of URL checker which may be composed using the [decorator pattern](http://en.wikipedia.org/wiki/Decorator_pattern). An URL checker exposes a [`#check(*urls)`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/AbstractUrlChecker#check-instance_method) method which has 2 variants:

- if a single URL is passed as an argument, it returns a single [`NDD::UrlChecker::Status`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/Status)
- if multiple URL are passed as arguments, it returns an array of [`NDD::UrlChecker::Status`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/Status)

A status has a code reflecting the result of the URL check. For the time being:

- valid codes are `direct` and `redirected`
- invalid codes are `failed`, `too_many_redirects` and `unknown_host`

### BlockingUrlChecker

[`NDD::UrlChecker::BlockingUrlChecker`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/BlockingUrlChecker) provides a serial URL checker using the standard [`Net:HTTP`](http://ruby-doc.org/stdlib-2.1.5/libdoc/net/http/rdoc/Net/HTTP.html) implementation.

```ruby
checker = NDD::UrlChecker::BlockingUrlChecker.new

status = checker.check('http://www.invalid123456789.com/')
status.valid? # => false
status.code   # => :unknown_host

status = checker.check('http://www.google.com/')
status.valid? # => true
status.code   # => :direct

statuses = checker.check('http://www.invalid123456789.com/', 'http://www.google.com/')
statuses[0].uri    # => 'http://www.invalid123456789.com/'
statuses[0].valid? # => false
statuses[0].code   # => :unknown_host
statuses[1].uri    # => 'http://www.google.com/'
statuses[1].valid? # => true
statuses[1].code   # => :direct
```

### ParallelUrlChecker

But this will be very time consuming if there is a lot of URL to check. Meet [`NDD::UrlChecker::ParallelUrlChecker`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/ParallelUrlChecker) which enables a very significant processing boost. For the time being, only a forked implementation is provided but a threaded one is planed.

```ruby
checker = NDD::UrlChecker::ParallelUrlChecker.new(parallelism: 100)
checker.check('http://www.invalid123456789.com/')
checker.check('http://www.google.com/')
```

### ReportingUrlChecker

For a nice looking report, use [`NDD::UrlChecker::ReportingUrlChecker`](http://www.rubydoc.info/github/ddidier/ndd-url_checker/NDD/UrlChecker/ReportingUrlChecker) which enables reporting capabilities using ERB templates. Several built-in templates are provided: CSV, HTML and JSON.

```ruby
checker = NDD::UrlChecker:: ReportingUrlChecker.new(delegate_checker)
statuses = checker.check('http://www.invalid123456789.com/', 'http://www.google.com/')
report_as_text = checker.report(:csv, '/some/report.csv')
report_as_text = checker.report(:html, '/some/report.html')
report_as_text = checker.report(:json, '/some/report.json')
report_as_text = checker.report('/some/template.erb', '/some/report.html')
```

## Copyright

Copyright (c) 2014 David DIDIER.
See `LICENSE.txt` for further details.
