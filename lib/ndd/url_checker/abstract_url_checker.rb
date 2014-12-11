require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # Abstract class, not very ruby-ish :)
    # @author David DIDIER
    class AbstractUrlChecker

      # Checks that the given URL are valid.
      # If there is only a single URL parameter, returns a NDD::UrlChecker::Status.
      # If there is only multiple URL parameters, returns an array of NDD::UrlChecker::Status.
      # @param urls [String|Array<String>] the URLs to check.
      # @return [Array<NDD::UrlChecker::Status|NDD::UrlChecker::Status>]
      def check(*urls)
        raise 'NDD::UrlChecker::UrlChecker#check must be implemented'
      end

    end
  end
end
