require 'logging'
require 'ndd/url_checker/abstract_url_checker'
require 'ndd/url_checker/status'
require 'net/http'
require 'net/https'

module NDD
  module UrlChecker

    # An URL checker using the blocking {Net::HTTP} class.
    # @author David DIDIER
    class BlockingUrlChecker < AbstractUrlChecker

      # Create a new instance.
      # @param maximum_redirects [Fixnum] the maximum number of redirects to follow before failing.
      # @param timeout [Fixnum] the number of seconds to wait before failing.
      def initialize(maximum_redirects: 5, timeout: 5)
        @logger = Logging.logger[self]
        @maximum_redirects = maximum_redirects
        @timeout = timeout
      end

      # Checks that the given URLs are valid.
      # @param urls [String, Array<String>] the URLs to check
      # @return [NDD::UrlChecker::Status, Array<NDD::UrlChecker::Status>] a single status for a single URL, an array
      #         of status for multiple parameters
      def check(*urls)
        @logger.debug "Checking #{urls.size} URL(s)"
        return check_single(urls.first) if urls.size < 2
        urls.map { |url| check_single(url) }
      end


      # -------------------------------------------------------------------------------------------------- private -----
      private

      # Checks that the given URL is valid.
      # @param url [String] the URL to check
      # @return [NDD::UrlChecker::Status]
      def check_single(url)
        begin
          @logger.debug "Checking: #{url}"
          status = Status.new(url)
          status = check_uri(URI.parse(url), status)
        rescue => error
          status = if unknown_host?(error)
                     status.unknown_host
                   else
                     status.failed(error)
                   end
        end
        @logger.debug "Checked: #{url} -> #{status.code.upcase}"
        status
      end

      # Checks that the given URI is valid.
      # @param uri [URI::HTTP] the URI to check.
      # @param status [NDD::UrlChecker::Status] the current status of the stack.
      # @return [NDD::UrlChecker::Status]
      def check_uri(uri, status)
        if status.uris.size() > @maximum_redirects
          return status.too_many_redirects
        end

        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = @timeout
        http.use_ssl = true if uri.scheme == 'https'
        http.start do
          path = (uri.path.empty?) ? '/' : uri.path
          http.request_get(path) do |response|
            case response
              when Net::HTTPSuccess then
                return on_success(uri, response, status)
              when Net::HTTPRedirection then
                return on_redirection(uri, response, status)
              else
                return on_error(uri, response, status)
            end
          end
        end
      end

      def on_success(uri, response, status)
        return status if status.redirected?
        status.direct
      end

      def on_redirection(uri, response, status)
        redirected_uri = redirected_uri(uri, response)
        redirected_status = status.redirected(redirected_uri)
        check_uri(redirected_uri, redirected_status)
      end

      def on_error(uri, response, status)
        # read the body while the socket is still open
        response.body if response.kind_of?(Net::HTTPResponse)
        status.failed(response)
      end

      def redirected_uri(uri, response)
        if response['location'].match(/https?:\/\//)
          URI(response['location'])
        else
          # If the redirect is relative we need to build a new URI using the current URI as a base.
          URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
        end
      end

      # FIXME: platform dependent?
      UNKNOWN_HOST_MESSAGE = 'getaddrinfo: Name or service not known'

      def unknown_host?(error)
        error.is_a?(SocketError) && error.message == UNKNOWN_HOST_MESSAGE
      end

    end
  end
end
