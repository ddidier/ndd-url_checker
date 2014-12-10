require 'spec_helper'

describe NDD::UrlChecker::ParallelUrlChecker do

  before(:all) do
    # Logging.logger.root.level = :debug
  end

  # ---------------------------------------------------------------------------------------------------------- MRI -----
  context 'when running MRI' do

    before(:all) do
      @old_engine = RUBY_ENGINE
      silence_warnings { RUBY_ENGINE = 'ruby' }
    end

    describe '#initialize' do
      it 'delegates to a ForkedUrlChecker instance' do
        expect(NDD::UrlChecker::ParallelUrlChecker.new.delegate).to be_a NDD::UrlChecker::ForkedUrlChecker
      end
    end

    it_behaves_like 'a single URL checker'

    after(:all) do
      silence_warnings { RUBY_ENGINE = @old_engine }
    end
  end

  # -------------------------------------------------------------------------------------------------------- JRuby -----
  context 'when running JRuby' do
    before(:all) do
      @old_engine = RUBY_ENGINE
      silence_warnings { RUBY_ENGINE = 'jruby' }
    end

    describe '#initialize' do
      it 'delegates to a ThreadedUrlChecker instance' do
        expect(NDD::UrlChecker::ParallelUrlChecker.new.delegate).to be_a NDD::UrlChecker::ThreadedUrlChecker
      end
    end

    # TODO
    # it_behaves_like 'a single URL checker'

    after(:all) do
      silence_warnings { RUBY_ENGINE = @old_engine }
    end
  end


  # ------------------------------------------------------------------------------------------------------ private -----
  private

  def silence_warnings(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = warn_level
    result
  end
end
