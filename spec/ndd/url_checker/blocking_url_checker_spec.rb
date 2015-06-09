require 'spec_helper'

RSpec.describe NDD::UrlChecker::BlockingUrlChecker do

  before(:all) do
    # Logging.logger.root.level = :debug
  end

  it_behaves_like 'a single URL checker'
  it_behaves_like 'a multiple URL checker'

end
