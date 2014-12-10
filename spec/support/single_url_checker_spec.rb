require 'spec_helper'

RSpec.shared_examples 'a single URL checker' do

  before(:all) do
    WebMock.allow_net_connect!
  end

  before(:each) do
    WebMock.reset!
  end

  # ------------------------------------------------------------------------------------------------------- direct -----
  context 'when the URL is valid' do
    let!(:stub) { stub_request(:get, 'http://www.valid.mock/').to_return(status: 200) }

    describe '#validate' do
      it 'returns true' do
        expect(subject.validate('http://www.valid.mock/')).to be_truthy
      end
    end

    describe '#check' do
      let (:status) { subject.check('http://www.valid.mock/') }

      it 'returns a status with a :direct code' do
        expect(status.code).to eq :direct
      end
      it 'returns a status with the requested URI' do
        expect(status.uris).to eq ['http://www.valid.mock/']
      end
      it 'returns a status with no error' do
        expect(status.error).to be_nil
      end
    end

    after(:each) do
      expect(stub).to have_been_requested
    end
  end

  # --------------------------------------------------------------------------------------------------- redirected -----
  context 'when there are not too many redirects' do
    let!(:stub1) { stub_redirect('http://www.redirect1.mock/', 'http://www.redirect2.mock/') }
    let!(:stub2) { stub_redirect('http://www.redirect2.mock/', 'http://www.redirect3.mock/') }
    let!(:stub3) { stub_redirect('http://www.redirect3.mock/', 'http://www.redirect4.mock/') }
    let!(:stub4) { stub_request(:get, 'http://www.redirect4.mock/').to_return(status: 200) }

    describe '#validate' do
      it 'returns true' do
        expect(subject.validate('http://www.redirect1.mock/')).to be_truthy
      end
    end

    describe '#check' do
      let (:status) { subject.check('http://www.redirect1.mock/') }

      it 'returns a status with a :direct code' do
        expect(status.code).to eq :redirected
      end

      it 'returns a status with the requested URI' do
        expect(status.uri).to eq 'http://www.redirect1.mock/'
      end

      it 'returns a status with the requested URIs' do
        expect(status.uris).to eq (1..4).to_a.map { |i| "http://www.redirect#{i}.mock/" }
      end
    end

    after(:each) do
      [stub1, stub2, stub3, stub4].each { |stub| expect(stub).to have_been_requested }
    end
  end

  # ------------------------------------------------------------------------------------------- too_many_redirects -----
  context 'when there are too many redirects' do
    let!(:stub1) { stub_redirect('http://www.redirect1.mock/', 'http://www.redirect2.mock/') }
    let!(:stub2) { stub_redirect('http://www.redirect2.mock/', 'http://www.redirect3.mock/') }
    let!(:stub3) { stub_redirect('http://www.redirect3.mock/', 'http://www.redirect4.mock/') }
    let!(:stub4) { stub_redirect('http://www.redirect4.mock/', 'http://www.redirect5.mock/') }
    let!(:stub5) { stub_redirect('http://www.redirect5.mock/', 'http://www.redirect6.mock/') }

    describe '#validate' do
      it 'returns false' do
        expect(subject.validate('http://www.redirect1.mock/')).to be_falsey
      end
    end

    describe '#check' do
      it 'returns UrlChecker::Direct' do
        result = subject.check('http://www.redirect1.mock/')
        expect(result).to be_kind_of NDD::UrlChecker::Status
        # expect(result).to be_kind_of UrlChecker::TooManyRedirect
        expect(result.uri).to eq 'http://www.redirect1.mock/'
        expect(result.uris).to eq (1..6).to_a.map { |i| "http://www.redirect#{i}.mock/" }
      end
    end

    after(:each) do
      [stub1, stub2, stub3, stub4, stub5].each { |stub| expect(stub).to have_been_requested }
    end
  end

  # ------------------------------------------------------------------------------------------------- unknown_host -----
  context 'when the URL cannot be resolved' do
    let!(:stub) {
      error = SocketError.new('getaddrinfo: Name or service not known')
      stub_request(:get, 'http://www.invalid.mock/').to_raise(error)
    }

    describe '#validate' do
      it 'returns false' do
        expect(subject.validate('http://www.invalid.mock/')).to be_falsey
      end
    end

    describe '#check' do
      let (:status) { subject.check('http://www.invalid.mock/') }

      it 'returns a status with a :unknown_host code' do
        expect(status.code).to eq :unknown_host
      end
      it 'returns a status with the requested URI' do
        expect(status.uri).to eq 'http://www.invalid.mock/'
      end
      it 'returns a status with no error' do
        expect(status.error).to be_nil
      end
    end

    after(:each) do
      expect(stub).to have_been_requested
    end
  end

  # ------------------------------------------------------------------------------------------------- socket error -----
  context 'when there is a socket error' do
    let!(:stub) { stub_request(:get, 'http://www.invalid.mock/').to_raise(SocketError) }

    describe '#validate' do
      it 'returns false' do
        expect(subject.validate('http://www.invalid.mock/')).to be_falsey
      end
    end

    describe '#check' do
      let (:status) { subject.check('http://www.invalid.mock/') }

      it 'returns a status with a :failed code' do
        expect(status.code).to eq :failed
      end
      it 'returns a status with the requested URI' do
        expect(status.uri).to eq 'http://www.invalid.mock/'
      end
      it 'returns a status with the raised error' do
        expect(status.error).to be_a SocketError
      end
    end

    after(:each) do
      expect(stub).to have_been_requested
    end
  end

  # -------------------------------------------------------------------------------------------------------- error -----
  context 'when there is an unexpected error' do
    let!(:stub) { stub_request(:get, 'http://www.error.mock/').to_raise('Some error') }

    describe '#validate' do
      it 'returns false' do
        expect(subject.validate('http://www.error.mock/')).to be_falsey
      end
    end

    describe '#check' do
      let (:status) { subject.check('http://www.error.mock/') }

      it 'returns a status with a :failed code' do
        expect(status.code).to eq :failed
      end
      it 'returns a status with the requested URI' do
        expect(status.uri).to eq 'http://www.error.mock/'
      end
      it 'returns a status with the raised error' do
        expect(status.error).to be_a StandardError
      end
    end

    after(:each) do
      expect(stub).to have_been_requested
    end
  end


  # ------------------------------------------------------------------------------------------------------ private -----
  private

  def stub_redirect(from, to)
    stub_request(:get, from).to_return(status: 301, headers: {Location: to})
  end
end

# expect(subject.valid?('http://www.google.fr')).to be_truthy
# expect(subject.valid?('http://www.google.fr/')).to be_truthy
# expect(subject.valid?('http://www.invalid123456789xyz.com')).to be_falsey
# expect(subject.valid?('http://www.invalid123456789xyz.com/')).to be_falsey
