require 'spec_helper'

RSpec.describe NDD::UrlChecker::Status do

  # ------------------------------------------------------------------------------------------------------ unknown -----
  context 'when initialized' do
    let(:uri) { 'http://www.example.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri) }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns the original URI' do
        expect(status.uris).to eq [uri]
      end
    end

    context '#code' do
      it 'returns :unknown' do
        expect(status.code).to eq :unknown
      end
    end

    context '#valid?' do
      it 'returns false' do
        expect(status.valid?).to be_falsey
      end
    end

    context '#invalid?' do
      it 'returns false' do
        expect(status.invalid?).to be_falsey
      end
    end

    context '#error' do
      it 'returns nil' do
        expect(status.error).to be_nil
      end
    end

    context '#direct' do
      let!(:new_status) { status.direct }
      it 'changes the code to :direct' do
        expect(status.code).to eq :direct
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#failed' do
      let!(:new_status) { status.failed(StandardError.new('some error')) }
      it 'changes the code to :failed' do
        expect(status.code).to eq :failed
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#redirected' do
      let!(:new_status) { status.redirected('http://www.redirected.com') }
      it 'changes the code to :redirected' do
        expect(status.code).to eq :redirected
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#too_many_redirects' do
      let!(:new_status) { status.too_many_redirects }
      it 'changes the code to :too_many_redirects' do
        expect(status.code).to eq :too_many_redirects
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#unknown_host' do
      it 'changes the code to :unknown_host' do
        status.unknown_host
        expect(status.code).to eq :unknown_host
      end
      it 'returns the status' do
        expect(status.unknown_host).to eq status
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com"\], @code=:unknown>$}
      end
    end
  end

  # ------------------------------------------------------------------------------------------------------- direct -----
  context 'when code is :direct' do
    let(:uri) { 'http://www.example.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri).direct }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns the original URI' do
        expect(status.uris).to eq [uri]
      end
    end

    context '#code' do
      it 'returns :direct' do
        expect(status.code).to eq :direct
      end
    end

    context '#valid?' do
      it 'returns true' do
        expect(status.valid?).to be_truthy
      end
    end

    context '#invalid?' do
      it 'returns false' do
        expect(status.invalid?).to be_falsey
      end
    end

    context '#error' do
      it 'returns nil' do
        expect(status.error).to be_nil
      end
    end

    context '#direct' do
      it 'raises an error' do
        expect { status.direct }.to raise_error(/from :direct to :direct is forbidden/)
      end
    end

    context '#failed' do
      it 'raises an error' do
        expect { status.failed(StandardError.new('some error')) }.to raise_error(/from :direct to :failed is forbidden/)
      end
    end

    context '#redirected' do
      it 'raises an error' do
        expect { status.redirected('http://www.redirected.com') }.to raise_error(/from :direct to :redirected is forbidden/)
      end
    end

    context '#too_many_redirects' do
      it 'raises an error' do
        expect { status.too_many_redirects }.to raise_error(/from :direct to :too_many_redirects is forbidden/)
      end
    end

    context '#unknown_host' do
      it 'raises an error' do
        expect { status.unknown_host }.to raise_error(/from :direct to :unknown_host is forbidden/)
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com"\], @code=:direct>$}
      end
    end
  end

  # ------------------------------------------------------------------------------------------------------- failed -----
  context 'when code is :failed' do
    let(:uri) { 'http://www.example.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri).failed(StandardError.new('some error')) }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns the original URI' do
        expect(status.uris).to eq [uri]
      end
    end

    context '#code' do
      it 'returns :failed' do
        expect(status.code).to eq :failed
      end
    end

    context '#valid?' do
      it 'returns false' do
        expect(status.valid?).to be_falsey
      end
    end

    context '#invalid?' do
      it 'returns true' do
        expect(status.invalid?).to be_truthy
      end
    end

    context '#error' do
      it 'returns the error' do
        expect(status.error).to eq StandardError.new('some error')
      end
    end

    context '#direct' do
      it 'raises an error' do
        expect { status.direct }.to raise_error(/from :failed to :direct is forbidden/)
      end
    end

    context '#failed' do
      it 'raises an error' do
        expect { status.failed(StandardError.new('some error')) }.to raise_error(/from :failed to :failed is forbidden/)
      end
    end

    context '#redirected' do
      it 'raises an error' do
        expect { status.redirected('http://www.redirected.com') }.to raise_error(/from :failed to :redirected is forbidden/)
      end
    end

    context '#too_many_redirects' do
      it 'raises an error' do
        expect { status.too_many_redirects }.to raise_error(/from :failed to :too_many_redirects is forbidden/)
      end
    end

    context '#unknown_host' do
      it 'raises an error' do
        expect { status.unknown_host }.to raise_error(/from :failed to :unknown_host is forbidden/)
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com"\], @code=:failed, @error=#<StandardError: some error>>$}
      end
    end
  end

  # --------------------------------------------------------------------------------------------------- redirected -----
  context 'when code is :redirected' do
    let(:uri) { 'http://www.example.com' }
    let(:redirect_uri) { 'http://www.redirected.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri).redirected(redirect_uri) }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns all the URI' do
        expect(status.uris).to eq [uri, redirect_uri]
      end
    end

    context '#code' do
      it 'returns :redirected' do
        expect(status.code).to eq :redirected
      end
    end

    context '#valid?' do
      it 'returns true' do
        expect(status.valid?).to be_truthy
      end
    end

    context '#invalid?' do
      it 'returns false' do
        expect(status.invalid?).to be_falsey
      end
    end

    context '#error' do
      it 'returns nil' do
        expect(status.error).to be_nil
      end
    end

    context '#direct' do
      it 'raises an error' do
        expect { status.direct }.to raise_error(/from :redirected to :direct is forbidden/)
      end
    end

    context '#failed' do
      let!(:new_status) { status.failed(StandardError.new('some error')) }
      it 'changes the code to :failed' do
        expect(status.code).to eq :failed
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#redirected' do
      let!(:new_status) { status.redirected('http://www.redirected.com') }
      it 'changes the code to :redirected' do
        expect(status.code).to eq :redirected
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#too_many_redirects' do
      let!(:new_status) { status.too_many_redirects }
      it 'changes the code to :too_many_redirects' do
        expect(status.code).to eq :too_many_redirects
      end
      it 'returns the status' do
        expect(new_status).to eq status
      end
    end

    context '#unknown_host' do
      it 'changes the code to :unknown_host' do
        status.unknown_host
        expect(status.code).to eq :unknown_host
      end
      it 'returns the status' do
        expect(status.unknown_host).to eq status
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com", "http://www.redirected.com"\], @code=:redirected>$}
      end
    end
  end

  # ------------------------------------------------------------------------------------------- too_many_redirects -----
  context 'when code is :too_many_redirects' do
    let(:uri) { 'http://www.example.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri).too_many_redirects }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns the original URI' do
        expect(status.uris).to eq [uri]
      end
    end

    context '#code' do
      it 'returns :too_many_redirects' do
        expect(status.code).to eq :too_many_redirects
      end
    end

    context '#valid?' do
      it 'returns false' do
        expect(status.valid?).to be_falsey
      end
    end

    context '#invalid?' do
      it 'returns true' do
        expect(status.invalid?).to be_truthy
      end
    end

    context '#error' do
      it 'returns nil' do
        expect(status.error).to be_nil
      end
    end

    context '#direct' do
      it 'raises an error' do
        expect { status.direct }.to raise_error(/from :too_many_redirects to :direct is forbidden/)
      end
    end

    context '#failed' do
      it 'raises an error' do
        expect { status.failed(StandardError.new('some error')) }.to raise_error(/from :too_many_redirects to :failed is forbidden/)
      end
    end

    context '#redirected' do
      it 'raises an error' do
        expect { status.redirected('http://www.redirected.com') }.to raise_error(/from :too_many_redirects to :redirected is forbidden/)
      end
    end

    context '#too_many_redirects' do
      it 'raises an error' do
        expect { status.too_many_redirects }.to raise_error(/from :too_many_redirects to :too_many_redirects is forbidden/)
      end
    end

    context '#unknown_host' do
      it 'raises an error' do
        expect { status.unknown_host }.to raise_error(/from :too_many_redirects to :unknown_host is forbidden/)
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com"\], @code=:too_many_redirects>$}
      end
    end
  end

  # ------------------------------------------------------------------------------------------------- unknown_host -----
  context 'when code is :unknown_host' do
    let(:uri) { 'http://www.example.com' }
    let(:status) { NDD::UrlChecker::Status.new(uri).unknown_host }

    context '#uri' do
      it 'returns the original URI' do
        expect(status.uri).to eq uri
      end
    end

    context '#uris' do
      it 'returns the original URI' do
        expect(status.uris).to eq [uri]
      end
    end

    context '#code' do
      it 'returns :unknown_host' do
        expect(status.code).to eq :unknown_host
      end
    end

    context '#valid?' do
      it 'returns false' do
        expect(status.valid?).to be_falsey
      end
    end

    context '#invalid?' do
      it 'returns true' do
        expect(status.invalid?).to be_truthy
      end
    end

    context '#error' do
      it 'returns nil' do
        expect(status.error).to be_nil
      end
    end

    context '#direct' do
      it 'raises an error' do
        expect { status.direct }.to raise_error(/from :unknown_host to :direct is forbidden/)
      end
    end

    context '#failed' do
      it 'raises an error' do
        expect { status.failed(StandardError.new('some error')) }.to raise_error(/from :unknown_host to :failed is forbidden/)
      end
    end

    context '#redirected' do
      it 'raises an error' do
        expect { status.redirected('http://www.redirected.com') }.to raise_error(/from :unknown_host to :redirected is forbidden/)
      end
    end

    context '#too_many_redirects' do
      it 'raises an error' do
        expect { status.too_many_redirects }.to raise_error(/from :unknown_host to :too_many_redirects is forbidden/)
      end
    end

    context '#unknown_host' do
      it 'raises an error' do
        expect { status.unknown_host }.to raise_error(/from :unknown_host to :unknown_host is forbidden/)
      end
    end

    context '#to_s' do
      it 'returns the status representation' do
        expect(status.to_s).to match %r{^#<NDD::UrlChecker::Status:0[xX][0-9a-fA-F]+ @uris=\["http://www.example.com"\], @code=:unknown_host>$}
      end
    end
  end

end
