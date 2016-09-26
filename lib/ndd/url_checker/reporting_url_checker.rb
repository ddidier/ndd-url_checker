require 'benchmark'
require 'erb'
require 'logging'
require 'ndd/url_checker'
require 'ostruct'

module NDD
  module UrlChecker

    # Wraps an instance of URL checker and provides reporting capabilities using ERB templates.
    # @author David DIDIER
    # @attr_reader delegate [#check] the delegate URL checker.
    class ReportingUrlChecker < AbstractUrlChecker

      attr_reader :delegate

      # Create a new instance.
      # @param delegate_checker [AbstractUrlChecker].
      def initialize(delegate_checker)
        @logger = Logging.logger[self]
        @delegate = delegate_checker
      end

      # Checks that the given URLs are valid.
      # @param urls [String, Array<String>] the URLs to check
      # @return [NDD::UrlChecker::Status, Array<NDD::UrlChecker::Status>] a single status for a single URL, an array
      #         of status for multiple parameters
      def check(*urls)
        results = nil
        benchmark = Benchmark.measure { results = @delegate.check(*urls) }
        @logger.debug "Checked #{urls.size} URL(s) benchmark: #{benchmark}"

        if urls.size > 1
          statuses = results.map { |status| StatusDecorator.new(status) }.sort_by { |status| status.uri }
        else
          statuses = [results].map { |status| StatusDecorator.new(status) }
        end

        @context = OpenStruct.new
        @context.statuses = statuses

        @context.urls = OpenStruct.new
        @context.urls.count = urls.size
        @context.urls.valid_count = statuses.select { |status| status.valid? }.size
        @context.urls.direct_count = statuses.select { |status| status.code == :direct }.size
        @context.urls.redirected_count = statuses.select { |status| status.code == :redirected }.size
        @context.urls.invalid_count = statuses.select { |status| status.invalid? }.size
        @context.urls.failed_count = statuses.select { |status| status.code == :failed }.size
        @context.urls.too_many_redirects_count = statuses.select { |status| status.code == :too_many_redirects }.size
        @context.urls.unknown_host_count = statuses.select { |status| status.code == :unknown_host }.size

        @context.benchmark = OpenStruct.new
        @context.benchmark.raw = benchmark
        @context.benchmark.total_duration = benchmark.real
        @context.benchmark.average_duration = benchmark.real / urls.size
        @context.benchmark.average_throughput= urls.size / benchmark.real

        results
      end

      # Creates a report about the previous check using the specified template. The result may be written to a file.
      # @param template [Symbol, String] a predefined template (:csv, :html, :json) or the path of a template file.
      # @param output_path [String, nil] the path of the output file.
      # @return [String] the report.
      def report(template, output_path=nil)
        template_path = template_path(template)
        template_content = ERB.new(File.new(template_path).read)
        report = template_content.result(@context.instance_eval { binding })

        if output_path
          @logger.info "Reporting to #{output_path}"
          File.open(output_path, 'w') { |file| file.write(report) }
        end

        report
      end


      # -------------------------------------------------------------------------------------------------- private -----
      private

      def template_path(symbol_or_path)
        case symbol_or_path
          when :csv then
            File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.csv.erb'))
          when :html then
            File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.html.erb'))
          when :json then
            File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.json.erb'))
          else
            symbol_or_path
        end
      end
    end
  end
end
