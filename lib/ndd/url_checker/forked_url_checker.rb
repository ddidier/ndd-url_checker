require 'cod'
require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/blocking_url_checker'
require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # An URL checker using forks to parallelize processing. To be used with MRI.
    # @author David DIDIER
    # @attr_reader delegate [#check] the delegate URL checker.
    # @attr_reader parallelism [Fixnum] the number of processes.
    class ForkedUrlChecker < AbstractUrlChecker

      attr_reader :delegate
      attr_reader :parallelism

      # Create a new instance.
      # @param delegate_checker [AbstractUrlChecker] defaults to {NDD::UrlChecker::BlockingUrlChecker}.
      # @param parallelism [Fixnum] the number of processes.
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
        return delegate.check(*urls) if urls.size < 2

        # for receiving results
        result_pipe = Cod.pipe
        # partition the URLs, but not too much :)
        url_slices = partition(urls, [parallelism, urls.size].min)
        # and distribute them among the workers
        pids = url_slices.each_with_index.map do |url_slice, index|
          fork { Worker.new(index, result_pipe, delegate).check(url_slice) }
        end

        # read back the results
        results = urls.map do |_|
          result = result_pipe.get
          @logger.debug("Processed URLs #{hash.size}/#{urls.size}")
          result
        end

        # kill all the workers
        pids.each { |pid| Process.kill(:TERM, pid) }

        results
      end


      # -------------------------------------------------------------------------------------------------- private -----
      private

      # Evenly distributes data into buckets.
      #
      # @example
      #     partition([1, 2, 3], 2)           #=> [[1, 3], [2]]
      #     partition([1, 2, 3, 4, 5, 6], 3)  #=> [[1, 4], [2, 5], [3, 6]]
      def partition(data, buckets)
        Array.new.tap do |slices|
          buckets.times.each { |_| slices << Array.new }
          data.each_with_index { |element, index| slices[index % buckets] << element }
        end
      end


      # ---------------------------------------------------------------------------------------------------- class -----
      # A simple worker class processing URL one by one.
      # @private
      class Worker
        def initialize(id, result_pipe, url_checker)
          @logger = Logging.logger[self]
          @id = id
          @result_pipe = result_pipe
          @url_checker = url_checker
        end

        def check(urls)
          @logger.debug("[worker #{@id}] Checking #{urls.size} URLs")
          urls.each do |url|
            @result_pipe.put(@url_checker.check(url))
          end
        end
      end

      private_constant :Worker
    end
  end
end
