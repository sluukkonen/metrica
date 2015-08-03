require "spec_helper"
require "jars/metrics-opentsdb-1.0.4.jar"

RSpec.describe Metrica::Reporters::OpenTSDBReporter do

  com.github.sps.metrics.OpenTsdbReporter.__persistent__ = true

  let(:reporter) { Metrica::Reporters::OpenTSDBReporter.new }

  it "should create a com.github.sps.metrics.OpenTSDBReporter" do
    expect(reporter.underlying).to be_a com.github.sps.metrics.OpenTsdbReporter
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
      reporter = Metrica::Reporters::OpenTSDBReporter.new(report_interval: 5)

      expect(reporter.underlying).
          to receive(:start).with(5, Metrica::TimeUnit::SECONDS)

      reporter.start
    end

    it "should set url correctly" do
      url = 'http://foo:80'

      expect(com.github.sps.metrics.opentsdb.OpenTsdb).
          to receive(:forService).with(url).and_call_original

      Metrica::Reporters::OpenTSDBReporter.new(url: url)
    end

  end
end