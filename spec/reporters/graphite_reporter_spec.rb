require "spec_helper"
require "jars/metrics-graphite-3.1.2.jar"

RSpec.describe Metrica::Reporters::GraphiteReporter do

  com.codahale.metrics.graphite.GraphiteReporter.__persistent__ = true

  let(:reporter) { Metrica::Reporters::GraphiteReporter.new }

  it "should create a com.codahale.metrics.graphite.GraphiteReporter" do
    expect(reporter.underlying).to be_a com.codahale.metrics.graphite.GraphiteReporter
  end

  context "Starting & Stopping" do

    it "should call #start on the underlying reporter" do
      expect(reporter.underlying).
          to receive(:start).with(30, Metrica::TimeUnit::SECONDS)

      reporter.start
    end

    it "should call #stop on the underlying reporter" do
      expect(reporter.underlying).to receive(:stop)

      reporter.stop
    end

  end

  context "Customizing" do

    it "should set report interval correctly" do
      reporter = Metrica::Reporters::GraphiteReporter.new(report_interval: 5)

      expect(reporter.underlying).
          to receive(:start).with(5, Metrica::TimeUnit::SECONDS)

      reporter.start
    end

    it "should set hostname correctly" do
      hostname = 'foo'

      expect(com.codahale.metrics.graphite.Graphite).
          to receive(:new).with(java.net.InetSocketAddress.new(hostname, 2003))

      Metrica::Reporters::GraphiteReporter.new(hostname: hostname)
    end

    it "should set port number correctly" do
      port = 2004

      expect(com.codahale.metrics.graphite.Graphite).
          to receive(:new).with(java.net.InetSocketAddress.new('localhost', port))

      Metrica::Reporters::GraphiteReporter.new(port: port)
    end

  end
end