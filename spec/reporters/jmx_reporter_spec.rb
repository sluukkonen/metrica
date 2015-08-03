require "spec_helper"

RSpec.describe Metrica::Reporters::ConsoleReporter do

  com.codahale.metrics.JmxReporter.__persistent__ = true

  let(:reporter) { Metrica::Reporters::JmxReporter.new }

  it "should create a com.codahale.metrics.ConsoleReporter" do
    expect(reporter.underlying).to be_a com.codahale.metrics.JmxReporter
  end

  context "Starting & Stopping" do

    it "should call #start on the underlying reporter" do
      expect(reporter.underlying).to receive(:start)

      reporter.start
    end

    it "should call #stop on the underlying reporter" do
      expect(reporter.underlying).to receive(:stop)

      reporter.stop
    end

  end

end