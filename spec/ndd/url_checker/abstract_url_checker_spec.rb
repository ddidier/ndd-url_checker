require 'spec_helper'

describe NDD::UrlChecker::AbstractUrlChecker do

  context '#validate' do
    it 'is not implemented' do
      expect { subject.validate('http://www.valid.mock/') }.to raise_error /must be implemented/
    end
  end

  context '#check' do
    it 'is not implemented' do
      expect { subject.check('http://www.valid.mock/') }.to raise_error /must be implemented/
    end
  end

end
