require "spec_helper"

RSpec.describe Metrica::MethodInstrumentation do

  # See http://wiki.jruby.org/Persistence
  Metrica::Timer.__persistent__ = true
  Metrica::Timer::Context.__persistent__ = true

  context "Without transaction support" do

    class TestWithoutTransactionSupport
      extend Metrica::MethodInstrumentation
      def test
        "test"
      end
      instrument_method :test, "test.metric"
    end

    class TestWithoutTransactionSupportThrowsException
      extend Metrica::MethodInstrumentation
      def test
        raise RuntimeError, "exception"
      end
      instrument_method :test, "test.metric.exception"
    end

    it "should return the result of the original method and measure the execution if a transaction is active" do
      Metrica::Transaction.perform do
        expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
        expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

        expect(TestWithoutTransactionSupport.new.test).to eq "test"
      end
    end

    it "should return the result of the original method and measure the execution even if a transaction isn't active" do
      expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
      expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

      expect(TestWithoutTransactionSupport.new.test).to eq "test"
    end

    it "should measure the execution even if the method throws an exception" do
      expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
      expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

      expect { TestWithoutTransactionSupportThrowsException.new.test }.to raise_error(RuntimeError)
    end

  end

  context "With transaction support" do

    class TestWithTransactionSupport
      extend Metrica::MethodInstrumentation
      def test
        "test"
      end
      instrument_method :test, "test.metric.transaction", within_transaction: true
    end

    class TestWithTransactionSupportThrowsException
      extend Metrica::MethodInstrumentation
      def test
        raise RuntimeError, "exception"
      end
      instrument_method :test, "test.metric.exception", within_transaction: true
    end

    it "should return the result of the original method and measure the execution if a transaction is active" do
      Metrica::Transaction.perform do
        expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
        expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

        expect(TestWithTransactionSupport.new.test).to eq "test"
      end
    end

    it "should not measure anything if a transaction isn't active" do
      expect_any_instance_of(Metrica::Timer).to_not receive(:time).and_call_original
      expect_any_instance_of(Metrica::Timer::Context).to_not receive(:stop).and_call_original

      expect(TestWithTransactionSupport.new.test).to eq "test"
    end

    it "should measure the execution even if the method throws an exception" do
      Metrica::Transaction.perform do
        expect_any_instance_of(Metrica::Timer).to receive(:time).and_call_original
        expect_any_instance_of(Metrica::Timer::Context).to receive(:stop).and_call_original

        expect { TestWithTransactionSupportThrowsException.new.test }.to raise_error(RuntimeError)
      end
    end

  end


end
