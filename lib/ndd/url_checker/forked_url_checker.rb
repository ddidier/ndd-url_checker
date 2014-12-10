require 'cod'
require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/blocking_url_checker'
require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # An URL checker using forks to parallelize processing. To be used with MRI.
    # @author David DIDIER
    class ForkedUrlChecker < AbstractUrlChecker

      attr_reader :delegate
      attr_reader :parallelism

      # Create a new instance.
      # @param [AbstractUrlChecker] delegate_checker the delegate checker (defaults to BlockingUrlChecker).
      # @param [Fixnum] parallelism the number of processes.
      def initialize(delegate_checker=nil, parallelism=10)
        @logger = Logging.logger[self]
        @delegate = delegate_checker || BlockingUrlChecker.new
        @parallelism = parallelism
      end

      def check(*urls)
        return delegate.check(*urls) if urls.size < 2
        process(urls, :check)
      end

      def validate(*urls)
        return delegate.validate(*urls) if urls.size < 2
        process(urls, :validate)
      end


      private

      def process(urls, method)
        # for receiving results
        result_pipe = Cod.pipe
        # partition the URLs, but not too much :)
        url_slices = partition(urls, [parallelism, urls.size].min)
        # and distribute them among the workers
        pids = url_slices.each_with_index.map do |url_slice, index|
          fork { Worker.new(index, result_pipe, delegate).send(method, url_slice) }
        end

        # read back the results
        results = urls.reduce({}) do |hash, _|
          result = result_pipe.get
          hash.merge!(result)
          @logger.debug("Processed URLs #{hash.size}/#{urls.size}")
          hash
        end

        # kill all the workers
        pids.each { |pid| Process.kill(:TERM, pid) }

        results
      end

      # Evenly distributes data into buckets. For example:
      #     partition([1, 2, 3], 2) => [[1, 3], [2]]
      #     partition([1, 2, 3, 4, 5, 6], 3) => [[1, 4], [2, 5], [3, 6]]
      def partition(data, buckets)
        Array.new.tap do |slices|
          buckets.times.each { |_| slices << Array.new }
          data.each_with_index { |element, index| slices[index % buckets] << element }
        end
      end


      # A simple worker class processing URL one by one.
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
            @result_pipe.put({url => @url_checker.check(url)})
          end
        end

        def validate(urls)
          @logger.debug("[worker #{@id}] Validating #{urls.size} URLs")
          urls.each do |url|
            @result_pipe.put({url => @url_checker.validate(url)})
          end
        end
      end

    end
  end
end
