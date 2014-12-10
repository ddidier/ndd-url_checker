require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # Abstract class, not very ruby-ish :)
    # @author David DIDIER
    class AbstractUrlChecker

      # Checks that the given URL are valid.
      # If there is only a single URL parameter, returns a NDD::UrlChecker::Status.
      # If there is only multiple URL parameters, returns a Hash of NDD::UrlChecker::Status indexed by their URI.
      # @param urls [String|Array<String>] the URLs to check.
      # @return [NDD::UrlChecker::Status|Hash<String => NDD::UrlChecker::Status>]
      def check(*urls)
        raise 'NDD::UrlChecker::UrlChecker#check must be implemented'
      end

      # Validates that the given URL are valid.
      # If there is only a single URL parameter, returns a boolean.
      # If there is only multiple URL parameters, returns a Hash of boolean indexed by their URI.
      # @param urls [String|Array<String>] the URLs to validate.
      # @return [NDD::UrlChecker::Status|Hash<String => Boolean>]
      def validate(*urls)
        raise 'NDD::UrlChecker::UrlChecker#validate must be implemented'
      end

    end
  end
end
