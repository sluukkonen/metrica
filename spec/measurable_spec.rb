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

  it "should return the result of the original method and measure the execution" do
    expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
    expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

    expect(Test.new.test).to eq "test"
  end

  class TestThrowsException
    include Metrica::Measurable
    def test
      raise RuntimeError, "exception"
    end
    instrument_method :test, "test.metric.exception"
  end

  it "should measure the execution even if the method throws and exception" do
    expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
    expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

    expect { TestThrowsException.new.test }.to raise_error(RuntimeError)
  end



end