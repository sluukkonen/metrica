require "spec_helper"

RSpec.describe Metrica::Measurable do

  # See http://wiki.jruby.org/Persistence
  Metrica::Timer.__persistent__ = true
  Metrica::Timer::Context.__persistent__ = true

  class Test
    include Metrica::Measurable
    def test
      "test"
    end
    instrument_method :test, "test.metric"

  end
  class TestThrowsException
    include Metrica::Measurable
    def test
      raise RuntimeError, "exception"
    end
    instrument_method :test, "test.metric.exception"
  end

  it "should return the result of the original method and measure the execution if a transaction is active" do
    Metrica::Transaction.perform do 
      expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
      expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

      expect(Test.new.test).to eq "test"
    end
  end

  it "should not measure anything if a transaction isn't active" do
    expect_any_instance_of(Metrica::Timer).to_not receive(:time).and_call_original
    expect_any_instance_of(Metrica::Timer::Context).to_not receive(:stop).and_call_original
    
    expect(Test.new.test).to eq "test"
  end

  it "should measure the execution even if the method throws and exception" do
    Metrica::Transaction.perform do
      expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
      expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

      expect { TestThrowsException.new.test }.to raise_error(RuntimeError)
    end
  end

end
