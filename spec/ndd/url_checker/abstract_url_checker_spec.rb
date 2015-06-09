require 'spec_helper'

RSpec.describe NDD::UrlChecker::AbstractUrlChecker do

  context '#check' do
    it 'is not implemented' do
      expect { subject.check('http://www.valid.mock/') }.to raise_error /must be implemented/
    end
  end

end
