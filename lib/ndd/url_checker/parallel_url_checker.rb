require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/forked_url_checker'
require 'ndd/url_checker/status'
require 'ndd/url_checker/threaded_url_checker'

module NDD
  module UrlChecker

    # Wraps an instance of {NDD::UrlChecker::ThreadedUrlChecker} or {NDD::UrlChecker::ForkedUrlChecker}
    # depending of the underlying Ruby implementation.
    # @author David DIDIER
    # @attr_reader delegate [NDD::UrlChecker::AbstractUrlChecker] the delegate checker.
    class ParallelUrlChecker < AbstractUrlChecker

      attr_reader :delegate

      # Create a new instance.
      # @param delegate_checker [AbstractUrlChecker] defaults to {NDD::UrlChecker::BlockingUrlChecker}.
      # @param parallelism [Fixnum] the number of threads or processes.
      def initialize(delegate_checker: nil, parallelism: 10)
        @logger = Logging.logger[self]

        @logger.debug "Ruby engine is #{RUBY_ENGINE}"
        if RUBY_ENGINE == 'jruby'
          @logger.info 'Creating a threaded URL checker'
          parallel_checker = ThreadedUrlChecker.new(delegate_checker: delegate_checker, parallelism: parallelism)
        else
          @logger.info 'Creating a forked URL checker'
          parallel_checker = ForkedUrlChecker.new(delegate_checker: delegate_checker, parallelism: parallelism)
        end

        @delegate = parallel_checker
      end

      # Checks that the given URLs are valid.
      # @param urls [String, Array<String>] the URLs to check
      # @return [NDD::UrlChecker::Status, Array<NDD::UrlChecker::Status>] a single status for a single URL, an array
      #         of status for multiple parameters
      def check(*urls)
        @delegate.check(*urls)
      end

    end
  end
end
