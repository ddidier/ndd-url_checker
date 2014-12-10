require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/blocking_url_checker'
require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # An URL checker using threads to parallelize processing. Does not work on MRI.
    # @author David DIDIER
    class ThreadedUrlChecker < AbstractUrlChecker

      attr_reader :delegate

      # Create a new instance.
      # @param [AbstractUrlChecker] delegate_checker defaults to {NDD::UrlChecker::BlockingUrlChecker}.
      # @param [Fixnum] parallelism the number of threads.
      def initialize(delegate_checker: nil, parallelism: 10)
        @logger = Logging.logger[self]
        @delegate = delegate_checker || BlockingUrlChecker.new
        @parallelism = parallelism
      end

      def check(*urls)
        # delegate.check(*urls)
        raise 'TODO'
      end

      def validate(*urls)
        # delegate.validate(*urls)
        raise 'TODO'
      end

    end
  end
end
