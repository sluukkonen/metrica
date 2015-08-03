require "spec_helper"

RSpec.describe Metrica::Reporters::ConsoleReporter do

  com.codahale.metrics.ConsoleReporter.__persistent__ = true

  let(:reporter) { Metrica::Reporters::ConsoleReporter.new }

  it "should create a com.codahale.metrics.ConsoleReporter" do
    expect(reporter.underlying).to be_a com.codahale.metrics.ConsoleReporter
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

    let(:reporter) do
      Metrica::Reporters::ConsoleReporter.new(report_interval: 5)
    end

    it "should set report interval correctly" do
      expect(reporter.underlying).
          to receive(:start).with(5, Metrica::TimeUnit::SECONDS)

      reporter.start
    end

  end



end