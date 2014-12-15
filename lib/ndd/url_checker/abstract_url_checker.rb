require 'ndd/url_checker/status'

module NDD
  module UrlChecker

    # Abstract class, not very ruby-ish :)
    # @abstract
    # @author David DIDIER
    class AbstractUrlChecker

      # Checks that the given URLs are valid.
      # @param urls [String, Array<String>] the URLs to check
      # @return [NDD::UrlChecker::Status, Array<NDD::UrlChecker::Status>] a single status for a single URL, an array
      #         of status for multiple parameters
      def check(*urls)
        raise 'NDD::UrlChecker::UrlChecker#check must be implemented'
      end

    end
  end
end
