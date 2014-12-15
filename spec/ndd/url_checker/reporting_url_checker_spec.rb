require 'spec_helper'

describe NDD::UrlChecker::ReportingUrlChecker do

  before(:all) do
    # Logging.logger.root.level = :debug
  end

  subject(:checker) { NDD::UrlChecker::ReportingUrlChecker.new(NDD::UrlChecker::BlockingUrlChecker.new) }

  it_behaves_like 'a single URL checker'
  it_behaves_like 'a multiple URL checker'


  # ------------------------------------------------------------------------------------------------------ #report -----
  describe '#report' do

    context 'when checking a single URL' do
      before(:each) do
        expected_result = NDD::UrlChecker::Status.new('http://www.google.fr').direct
        checker = double
        expect(checker).to receive(:check).and_return(expected_result)

        @report_checker = NDD::UrlChecker::ReportingUrlChecker.new(checker)
        @report_checker.check(expected_result.uri)
      end

      it 'creates an HTML report' do
        actual_report = actual_report(@report_checker, :html, 'single_url.html')
        expected_report = expected_report('single_url.html')
        expect(actual_report).to eq expected_report
      end

      it 'creates a custom report' do
        custom_template = File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker/custom.txt.erb'))
        actual_report = actual_report(@report_checker, custom_template, 'single_url.txt')
        expected_report = expected_report('single_url.txt')
        expect(actual_report).to eq expected_report
      end
    end

    context 'when checking multiple URLs' do
      before(:each) do
        expected_results = [
            NDD::UrlChecker::Status.new('http://www.google.fr').direct,
            NDD::UrlChecker::Status.new('http://www.google.com').direct,
            NDD::UrlChecker::Status.new('http://www.google.de').failed('some error')
        ]
        checker = double
        expect(checker).to receive(:check).and_return(expected_results)

        @report_checker = NDD::UrlChecker::ReportingUrlChecker.new(checker)
        @report_checker.check(*expected_results.map { |status| status.uri })
      end

      it 'creates an HTML report' do
        actual_report = actual_report(@report_checker, :html, 'multiple_urls.html')
        expected_report = expected_report('multiple_urls.html')
        expect(actual_report).to eq expected_report
      end

      it 'creates a custom report' do
        custom_template = File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker/custom.txt.erb'))
        actual_report = actual_report(@report_checker, custom_template, 'multiple_urls.txt')
        expected_report = expected_report('multiple_urls.txt')
        expect(actual_report).to eq expected_report
      end
    end
  end


  # ------------------------------------------------------------------------------------------------------ private -----
  private

  def actual_report(report_checker, report_type, output_file_name)
    # actual_file = '/tmp/multiple_urls.html'
    actual_file = Tempfile.new(output_file_name)
    actual_report = report_checker.report(report_type, actual_file)
    expect(actual_report).to eq actual_file.read
    actual_report.gsub(/^\s+/, '').gsub(/<td>[\d\.e-]+ second\(s\)<\/td>/, '<td>XXX second(s)</td>')
  end

  def expected_report(expected_file_name)
    expected_path = File.expand_path(File.join(File.dirname(__FILE__), 'reporting_url_checker/' + expected_file_name))
    expected_report = File.new(expected_path).read
    expected_report.gsub(/^\s+/, '')
  end
end
