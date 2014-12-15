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

      def check(*urls)
        results = nil
        benchmark = Benchmark.measure { results = @delegate.check(*urls) }
        @logger.debug "Checking #{urls.size} URL(s) benchmark: #{benchmark}"

        if urls.size > 1
          @context = OpenStruct.new(
              {
                  benchmark: benchmark,
                  results: results.sort_by { |status| status.uri }
              })
        else
          @context = OpenStruct.new(
              {
                  benchmark: benchmark,
                  results: [results]
              })
        end

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
            # File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.csv.erb'))
            raise 'TODO'
          when :html then
            File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.html.erb'))
          when :json then
            # File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker.json.erb'))
            raise 'TODO'
          else
            symbol_or_path
        end
      end
    end
  end
end
