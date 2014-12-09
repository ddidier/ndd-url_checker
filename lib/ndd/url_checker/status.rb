module NDD
  module UrlChecker

    # The result of a URI test.
    # @author David DIDIER
    # @attr_reader [String] code the state
    # @attr_reader [String|StandardError] the last error if any
    # @attr_reader [Array<String>] uris the list of requested URI
    class Status

      attr_reader :code
      attr_reader :error
      attr_reader :uris

      # Create a new NDD::UrlChecker::Status instance in the unknown state.
      # @param [String|URI::HTTP] uri the requested URI.
      def initialize(uri)
        @uris = [uri.to_s]
        @code = :unknown
      end

      # Returns the first requested URI.
      # @return [String] the first requested URI.
      def uri
        uris.first
      end

      # Note that the code :unknown is neither valid nor invalid.
      # @return [Boolean] true if valid, false otherwise.
      def valid?
        VALID_CODES.include? @code
      end

      # Note that the code :unknown is neither valid nor invalid.
      # @return [Boolean] true if invalid, false otherwise.
      def invalid?
        INVALID_CODES.include? @code
      end


      # When the URI is valid without any redirect.
      # @return [NDD::UrlChecker::Status] self.
      def direct
        update_code(:direct, %i(unknown))
      end

      # When a generic error is raised.
      # @param [StandardError|String] error the generic error.
      # @return [NDD::UrlChecker::Status] self.
      def failed(error)
        @error = error
        update_code(:failed, %i(unknown redirected))
      end

      # Adds a new URI to the redirected URI list.
      # @param [String|URI::HTTP] uri the redirection URI.
      # @return [NDD::UrlChecker::Status] self.
      def redirected(uri)
        @uris << uri.to_s
        update_code(:redirected, %i(unknown redirected))
      end

      # When there are too many redirects.
      # @return [NDD::UrlChecker::Status] self.
      def too_many_redirects
        update_code(:too_many_redirects, %i(unknown redirected))
      end

      # When the host cannot be resolved.
      # @return [NDD::UrlChecker::Status] self.
      def unknown_host
        update_code(:unknown_host, %i(unknown redirected))
      end


      # @return [Boolean] true if redirected, false otherwise.
      def redirected?
        @code == :redirected
      end


      private

      VALID_CODES = %i(direct redirected).freeze
      INVALID_CODES = %i(failed too_many_redirects unknown_host).freeze

      # Updates the code if the transition is valid.
      # @param code [Symbol] the new code.
      # @param valid_source_codes [Array<Symbol>] the codes from which the transition can happen.
      # @return [NDD::UrlChecker::Status] self.
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
