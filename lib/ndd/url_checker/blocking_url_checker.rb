require 'net/http'
require 'net/https'
require 'logging'
require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # An URL checker using the blocking Net::HTTP class.
    # @author David DIDIER
    class BlockingUrlChecker

      # Create a new instance.
      # @param [Fixnum] maximum_redirects the maximum number of redirects before failing.
      # @param [Fixnum] timeout the number of seconds to wait before failing.
      def initialize(maximum_redirects=5, timeout=5)
        @logger = Logging.logger[self]
        @maximum_redirects = maximum_redirects
        @timeout = timeout
      end

      # Checks that the given URL are valid.
      # If there is only a single URL parameter, returns a NDD::UrlChecker::Status.
      # If there is only multiple URL parameters, returns a Hash of NDD::UrlChecker::Status indexed by their URI.
      # @param [String|Array<String>] urls
      # @return [NDD::UrlChecker::Status|Hash<String => NDD::UrlChecker::Status>]
      def check(*urls)
        @logger.info "Checking #{urls.size} URL(s)"
        return check_single(urls.first) if urls.size == 1
        Hash[urls.map { |url| [url, check_single(url)] }]
      end

      # Validates that the given URL are valid.
      # If there is only a single URL parameter, returns a boolean.
      # If there is only multiple URL parameters, returns a Hash of boolean indexed by their URI.
      # @param [String|Array<String>] urls
      # @return [NDD::UrlChecker::Status|Hash<String => Boolean>]
      def validate(*urls)
        @logger.info "Validating #{urls.size} URL(s)"
        return validate_single(urls.first) if urls.size == 1
        Hash[urls.map { |url| [url, validate_single(url)] }]
      end


      private

      # Checks that the given URL is valid.
      # @param [String] url
      # @return [NDD::UrlChecker::Status]
      def check_single(url)
        begin
          @logger.debug "Checking: #{url}"
          status = check_uri(URI.parse(url), Status.new(url))
        rescue => error
          status = if unknown_host?(error)
                     Status.new(url).unknown_host
                   else
                     Status.new(url).failed(error)
                   end
        end
        @logger.debug "Checked: #{url} -> #{status.code.upcase}"
        status
      end

      # Validates that the given URL are valid.
      # @param [String] url
      # @return [Boolean]
      def validate_single(url)
        @logger.debug "Validating: #{url}"
        check_single(url).valid?
      end

      # Checks that the given URL is valid.
      # @param [URI::HTTP] uri the URI to check
      # @param [NDD::UrlChecker::Status] status the current status of the stack
      # @return [NDD::UrlChecker::Status]
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

      # FIXME: platform dependent?
      UNKNOWN_HOST_MESSAGE = 'getaddrinfo: Name or service not known'

      def unknown_host?(error)
        error.is_a?(SocketError) && error.message == UNKNOWN_HOST_MESSAGE
      end

    end
  end
end
