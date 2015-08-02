require 'spec_helper'

describe Metrica do

  let(:registry) { Metrica.registry }

  def metric(metric_set)
    metric_set.values.first
  end

  def name(metric_set)
    metric_set.keys.first
  end

  context "Metric registry" do

    it "should be a com.codahale.metrics.MetricRegistry" do
      expect(registry).to be_a com.codahale.metrics.MetricRegistry
    end

  end

  context "Configuration" do

    it "should return the curent configuration" do
      expect(Metrica.config).to be_a Metrica::Configuration
    end

    it "should be possible to reconfigure it on the fly" do
      Metrica.configure { |config| config.environments = ['staging'] }

      expect(Metrica.config.environments).to eq ['staging']
    end

  end

  context "Timers" do

    let(:timer) { Metrica.timer("test-timer") }

    it "should be a com.codahale.metrics.Timer" do
      expect(timer).to be_a com.codahale.metrics.Timer
    end

    it "is added to the registry" do
      expect(metric(registry.get_timers)).to eq timer
    end

    it "has the correct name" do
      expect(name(registry.get_timers)).to eq "test-timer"
    end
  end

  context "Gauges" do

    let(:gauge) do
      Metrica.gauge("test-gauge") { 5 }
    end

    it "should be a com.codahale.metrics.Gauge" do
      expect(gauge).to be_a com.codahale.metrics.Gauge
    end

    it "is added to the registry" do
      expect(metric(registry.get_gauges).call).to eq 5
    end

    it "has the correct name" do
      expect(name(registry.get_gauges)).to eq "test-gauge"
    end
  end

  context "Meters" do

    let(:meter) { Metrica.meter("test-meter") }

    it "should be a com.codahale.metrics.Meter" do
      expect(meter).to be_a com.codahale.metrics.Meter
    end

    it "is added to the registry" do
      expect(metric(registry.get_meters)).to eq meter
    end

    it "has the correct name" do
      expect(name(registry.get_meters)).to eq "test-meter"
    end
  end

  context "Histograms" do

    let(:histogram) { Metrica.histogram("test-histogram") }

    it "should be a com.codahale.metrics.Histogram" do
      expect(histogram).to be_a com.codahale.metrics.Histogram
    end

    it "is added to the registry" do
      expect(metric(registry.get_histograms)).to eq histogram
    end

    it "has the correct name" do
      expect(name(registry.get_histograms)).to eq "test-histogram"
    end

  end

  context "Adding a custom Metric" do

    let(:custom_metric) { Metrica::Timer.new(Metrica::SlidingTimeWindowReservoir.new(5, Metrica::TimeUnit::SECONDS)) }

    it "is possible to register a custom metric" do
      expect(Metrica.register("custom-metric", custom_metric)).
          to be_a com.codahale.metrics.Metric
    end
  end

end
