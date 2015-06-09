require 'spec_helper'

# ----------------------------------------------------------------------------------------------------------------------
RSpec.shared_examples 'a status' do |code|
  context '#uri' do
    it 'is decorated' do
      expect(decorator.uri).to eq uri
    end
  end

  context '#code' do
    it 'is decorated' do
      expect(decorator.code).to eq code
    end
  end
end

# ----------------------------------------------------------------------------------------------------------------------

RSpec.describe NDD::UrlChecker::StatusDecorator do

  let(:uri) { 'http://www.example.com' }
  let(:status) { NDD::UrlChecker::Status.new(uri) }
  let(:decorator) { NDD::UrlChecker::StatusDecorator.new(status) }

  let(:redirect_uri_1) { 'http://www.redirected1.com' }
  let(:redirect_uri_2) { 'http://www.redirected2.com' }
  let(:redirect_uri_3) { 'http://www.redirected3.com' }


  # ------------------------------------------------------------------------------------------------------- direct -----
  context 'when code is :direct' do
    before(:each) { status.direct }

    it_behaves_like 'a status', :direct

    context '#details_title' do
      it 'returns nil' do
        expect(decorator.details_title).to be_nil
      end
    end

    context '#details_body' do
      it 'returns nil' do
        expect(decorator.details_body).to be_nil
      end
    end
  end


  # ------------------------------------------------------------------------------------------------------- failed -----
  context 'when code is :failed' do
    context 'and received a Net::HTTPResponse' do
      before(:each) do
        response = Net::HTTPForbidden.new('1.1', 403, 'forbidden!')
        status.failed(response)
        allow(response).to receive(:body).and_return('The forbidden body!')
      end

      it_behaves_like 'a status', :failed

      context '#details_title' do
        it 'returns the name of the class' do
          expect(decorator.details_title).to eq 'Net::HTTPForbidden'
        end
      end

      context '#details_body' do
        it 'returns the body of the response' do
          expect(decorator.details_body).to eq 'The forbidden body!'
        end
      end
    end
  end

  # --------------------------------------------------------------------------------------------------- redirected -----
  context 'when code is :redirected' do
    context 'and redirected 1 time' do
      before(:each) { status.redirected(redirect_uri_1) }

      it_behaves_like 'a status', :redirected

      context '#details_title' do
        it 'returns the number of redirect' do
          expect(decorator.details_title).to eq 1
        end
      end

      context '#details_body' do
        it 'returns the list of redirected URIs' do
          expect(decorator.details_body).to eq <<-DOC.gsub(/^ +/, '')
            - http://www.example.com
            - http://www.redirected1.com
          DOC
        end
      end
    end

    context 'and redirected 3 times' do
      before(:each) do
        status
            .redirected(redirect_uri_1)
            .redirected(redirect_uri_2)
            .redirected(redirect_uri_3)
      end

      it_behaves_like 'a status', :redirected

      context '#details_title' do
        it 'returns the number of redirect' do
          expect(decorator.details_title).to eq 3
        end
      end

      context '#details_body' do
        it 'returns the list of redirected URIs' do
          expect(decorator.details_body).to eq <<-DOC.gsub(/^ +/, '')
            - http://www.example.com
            - http://www.redirected1.com
            - http://www.redirected2.com
            - http://www.redirected3.com
          DOC
        end
      end
    end
  end

  # ------------------------------------------------------------------------------------------- too_many_redirects -----
  context 'when code is :too_many_redirects' do
    context 'and redirected 1 time' do
      before(:each) { status.redirected(redirect_uri_1).too_many_redirects }

      it_behaves_like 'a status', :too_many_redirects

      context '#details_title' do
        it 'returns the number of redirect' do
          expect(decorator.details_title).to eq 1
        end
      end

      context '#details_body' do
        it 'returns the list of redirected URIs' do
          expect(decorator.details_body).to eq <<-DOC.gsub(/^ +/, '')
            - http://www.example.com
            - http://www.redirected1.com
          DOC
        end
      end
    end

    context 'and redirected 3 times' do
      before(:each) do
        status
            .redirected(redirect_uri_1)
            .redirected(redirect_uri_2)
            .redirected(redirect_uri_3)
            .too_many_redirects
      end

      it_behaves_like 'a status', :too_many_redirects

      context '#details_title' do
        it 'returns the number of redirect' do
          expect(decorator.details_title).to eq 3
        end
      end

      context '#details_body' do
        it 'returns the list of redirected URIs' do
          expect(decorator.details_body).to eq <<-DOC.gsub(/^ +/, '')
            - http://www.example.com
            - http://www.redirected1.com
            - http://www.redirected2.com
            - http://www.redirected3.com
          DOC
        end
      end
    end
  end

  # ------------------------------------------------------------------------------------------------- unknown_host -----
  context 'when code is :unknown_host' do
    before(:each) { status.unknown_host }

    it_behaves_like 'a status', :unknown_host

    context '#code_as_css' do
      it 'returns a CSS class suffix' do
        expect(decorator.code_as_css).to eq 'unknown-host'
      end
    end

    context '#details_title' do
      it 'returns the unknown URI' do
        # TODO
        expect(decorator.details_title).to be_nil
      end
    end

    context '#details_body' do
      it 'returns the list of redirected URIs' do
        # TODO
        # expect(decorator.details_body).to eq "- http://www.example.com\n- http://www.redirected1.com\n"
        expect(decorator.details_body).to be_nil
      end
    end
  end
end
