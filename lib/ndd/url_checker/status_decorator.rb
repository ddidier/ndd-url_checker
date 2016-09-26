require 'delegate'

module NDD
  module UrlChecker

    # Decorate a [Status] for reporting.
    # @author David DIDIER
    class StatusDecorator < SimpleDelegator

      # Returns the CSS class associated with the status.
      def code_as_css
        code.to_s.gsub(/_/, '-')
      end

      # Returns:
      # - nil if the status is :direct
      # - the number of redirections if the status is :redirected or :too_many_redirects
      # - the error if the status is :failed
      # - the last URL if the status is :unknown_host
      def details_title
        case code
          when :direct then
            nil
          when :redirected then
            uris.size - 1
          when :failed then
            return nil unless error
            return error.class.to_s
          when :too_many_redirects then
            uris.size - 1
          when :unknown_host then
            return uris.last
        end
      end

      # Returns:
      # - nil if the status is :direct
      # - all the URLs if the status is :redirected or :too_many_redirects or :unknown_host
      # - the error message if the status is :failed
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
            uris.map { |uri| "- #{uri}\n" }.join
        end
      end

      # Returns an HTML description of the status.
      def details_body_as_html
        body = <<-HTML.gsub(/^ +/, '')
          <p><em>Status:</em> #{code}</p>
          <p><em>URIs:</em><p>
          <ol>#{uris.map { |uri| "<li>#{uri}</li>" }.join}</ol>
        HTML

        if error
          body += "<p><em>Error:</em> #{error.class.to_s}</p>"
          body += "<p><pre>#{error.body}</pre></p>" if error.kind_of?(Net::HTTPResponse)
        end

        body
      end
    end

  end
end
