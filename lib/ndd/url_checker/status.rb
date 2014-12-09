module NDD
  module UrlChecker

    # The result of a URI test.
    class Status

      attr_reader :code
      attr_reader :error
      attr_reader :uris

      # Create a new NDD::UrlChecker::Status instance in the unknown state.
      # @param uri [String|URI::HTTP] the requested URI.
      def initialize(uri)
        @uris = [uri.to_s]
        @code = :unknown
      end

      # Returns the first requested URI.
      # @return [String] the first requested URI.
      def uri
        uris.first
      end

      # Returns true if valid, false otherwise.
      # The code :unknown is neither valid nor invalid.
      def valid?
        VALID_CODES.include? @code
      end

      # Returns true if invalid, false otherwise.
      # The code :unknown is neither valid nor invalid.
      def invalid?
        INVALID_CODES.include? @code
      end


      # When the URI is valid without any redirect.
      def direct
        update_code(:direct, %i(unknown))
      end

      # When a generic error is raised.
      # @param error [StandardError|String] the error.
      def failed(error)
        @error = error
        update_code(:failed, %i(unknown redirected))
      end

      # Adds a new URI to the redirected URI list.
      # @param uri [String|URI::HTTP] the redirection URI.
      def redirected(uri)
        @uris << uri.to_s
        update_code(:redirected, %i(unknown redirected))
      end

      # When there are too many redirects.
      def too_many_redirects
        update_code(:too_many_redirects, %i(unknown redirected))
      end

      # When the host cannot be resolved.
      def unknown_host
        update_code(:unknown_host, %i(unknown redirected))
      end



      private

      VALID_CODES = %i(direct redirected).freeze
      INVALID_CODES = %i(failed too_many_redirects unknown_host).freeze

      # @param code [Symbol] the new code.
      # @param valid_source_codes [Array] the codes from which the transition can happen.
      def update_code(code, valid_source_codes)
        unless valid_source_codes.include?(@code)
          raise "Changing the status code from :#{@code} to :#{code} is forbidden"
        end
        @code = code
        self
      end

    end
  end
end
