require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/blocking_url_checker'
require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # An URL checker using threads to parallelize processing. Does not work on MRI.
    # @author David DIDIER
    # @attr_reader delegate [#check] the delegate URL checker.
    # @attr_reader parallelism [Fixnum] the number of threads.
    class ThreadedUrlChecker < AbstractUrlChecker

      attr_reader :delegate
      attr_reader :parallelism

      # Create a new instance.
      # @param delegate_checker [AbstractUrlChecker] defaults to {NDD::UrlChecker::BlockingUrlChecker}.
      # @param parallelism [Fixnum] the number of threads.
      def initialize(delegate_checker: nil, parallelism: 10)
        @logger = Logging.logger[self]
        @delegate = delegate_checker || BlockingUrlChecker.new
        @parallelism = parallelism
      end

      # Checks that the given URLs are valid.
      # @param urls [String, Array<String>] the URLs to check
      # @return [NDD::UrlChecker::Status, Array<NDD::UrlChecker::Status>] a single status for a single URL, an array
      #         of status for multiple parameters
      def check(*urls)
        # delegate.check(*urls)
        raise 'TODO'
      end

    end
  end
end
