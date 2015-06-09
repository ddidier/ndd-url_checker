require 'delegate'

module NDD
  module UrlChecker

    # Decorate a [Status] for reporting.
    # @author David DIDIER
    class StatusDecorator < SimpleDelegator

      def code_as_css
        code.to_s.gsub(/_/, '-')
      end

      def details_title
        case code
          when :direct then
            nil
          when :redirected then
            uris.size - 1
          when :failed then
            return nil unless error
            error.kind_of?(String) ? error : error.class.to_s
          when :too_many_redirects then
            uris.size - 1
          when :unknown_host then
            # TODO
            nil
        end
      end

      def details_body
        case code
          when :direct then
            nil
          when :redirected then
            uris.map { |uri| "- #{uri}\n" }.join
          when :failed then
            return nil unless error
            return error.body if error.kind_of?(Net::HTTPResponse)
            return error.to_s
          when :too_many_redirects then
            uris.map { |uri| "- #{uri}\n" }.join
          when :unknown_host then
            nil
        end
      end
    end

  end
end
