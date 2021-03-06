require 'spec_helper'

# @param [Boolean] skip_verify because a forked process cannot be verified
RSpec.shared_examples 'a multiple URL checker' do |skip_verify|

  before(:all) do
    WebMock.allow_net_connect!
  end

  before(:each) do
    WebMock.reset!
  end


  # ------------------------------------------------------------------------------------------------- multiple URL -----
  context 'when there are multiple URLs' do
    let!(:stub1) { stub_request(:get, 'http://www.valid.mock/').to_return(status: 200) }
    let!(:stub2) { stub_request(:get, 'http://www.unknown.mock/').to_raise(SocketError) }

    describe '#check' do
      it 'returns a map of the results indexed by the URI' do
        results = subject.check('http://www.valid.mock/', 'http://www.unknown.mock/')
        expect(results).to have(2).items
        results_hash = results.reduce({}) { |hash, result| hash[result.uri] = result; hash }

        status1 = results_hash['http://www.valid.mock/']
        expect(status1.code).to eq :direct
        expect(status1.uri).to eq 'http://www.valid.mock/'
        expect(status1.error).to be_nil

        status2 = results_hash['http://www.unknown.mock/']
        expect(status2.code).to eq :failed
        expect(status2.uri).to eq 'http://www.unknown.mock/'
        expect(status2.error).to be_a StandardError
      end
    end

    after(:each) do
      unless skip_verify
        expect(stub1).to have_been_requested
        expect(stub2).to have_been_requested
      end
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
