require 'spec_helper'

describe NDD::UrlChecker::ForkedUrlChecker do

  before(:all) do
    # Logging.logger.root.level = :debug
  end

  it_behaves_like 'a single URL checker'
  it_behaves_like 'a multiple URL checker', skip_verify = true

end
