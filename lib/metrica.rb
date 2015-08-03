require "metrica_jars"

require_relative "metrica/version"
require_relative "metrica/configuration"
require_relative "metrica/reporter"
require_relative "metrica/scheduled_reporter"
require_relative "metrica/reporters/console_reporter"
require_relative "metrica/reporters/jmx_reporter"
require_relative "metrica/reporters/graphite_reporter"
require_relative "metrica/reporters/opentsdb_reporter"

module Metrica

  # Import some useful classes to the Metrica namespace.
  # The metrics
  java_import "com.codahale.metrics.Timer"
  java_import "com.codahale.metrics.Gauge"
  java_import "com.codahale.metrics.Histogram"
  java_import "com.codahale.metrics.Meter"
  # The reservoirs
  java_import "com.codahale.metrics.ExponentiallyDecayingReservoir"
  java_import "com.codahale.metrics.SlidingTimeWindowReservoir"
  java_import "com.codahale.metrics.SlidingWindowReservoir"
  java_import "com.codahale.metrics.UniformReservoir"
  # Regisry and other useful stuff.
  java_import "com.codahale.metrics.MetricRegistry"
  java_import "java.util.concurrent.TimeUnit"

  @registry = MetricRegistry.new
  @config = Configuration.new

  class << self

    # Returns the central metrics registry.
    #
    # @!attribute [r] registry
    # @return [com.codahale.metrics.MetricRegistry] The central metrics registry.
    attr_reader :registry

    # Returns the configuration object.
    #
    # @!attribute [r] configuration
    # @return [Metrica::Configuration] Returns the current configuration.
    attr_reader :config

    # Creates a new counter with the specified name.
    #
    # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Counter.html
    # @param name [String] The name of the counter.
    # @return [com.codahale.metrics.Counter]
    def counter(name)
      @registry.counter(name)
    end

    # Creates a new gauge with the specified name. The value returned by the
    # block at any given time determines the value of the gauge.
    #
    # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Gauge.html
    # @param name [String] The name of the gauge.
    # @param block [Proc] A block that determines the value of the gauge.
    # @return [com.codahale.metrics.Gauge]
    def gauge(name, &block)
      @registry.register(name, block.to_java(com.codahale.metrics.Gauge))
    end

    # Creates a new histogram with the specified name.
    #
    # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Histogram.html
    # @param name [String] The name of the histogram.
    # @return [com.codahale.metrics.Histogram]
    def histogram(name)
      @registry.histogram(name)
    end

    # Creates a new timer with the specified name.
    #
    # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Timer.html
    # @param name [String] The name of the timer.
    # @return [com.codahale.metrics.Timer]
    def timer(name)
      @registry.timer(name)
    end

    # Adds a metric to the registry under the given name. Use this method if
    # you need to customize the metric and can't use the default methods like
    # +Metrica.timer+.
    #
    # @param name [String] The name of the metric.
    # @param metric [com.codahale.metrics.Metric] The metric itself.
    def register(name, metric)
      @registry.register(name, metric)
    end

    # Returns a new meter with the specified name.
    #
    # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Meter.html
    # @param name [String] The name of the timer.
    # @return [com.codahale.metrics.Meter]
    def meter(name)
      @registry.meter(name)
    end

    # Allows you to configure Metrica.
    # @yields
    # @yieldparam [Metrica::Configuration] config The configuration instance.
    def configure
      yield @config if block_given?
    end

    # Starts all configured Reporters. If you're using Rails, calling this
    # method is not necessary as long as you've configured the environments
    # correctly.
    def start
      @config.reporters.each(&:start)
    end

    # Stops all configured Reporters.
    def stop
      @config.reporters.each(&:stop)
    end

  end

end

# Give a nicer Ruby API to the Timer class.
# @private
class Metrica::Timer
  def measure
    context = time
    yield
  ensure
    context.stop
  end
end

require_relative "metrica/measurable"
require_relative "metrica/rack/middleware"
require_relative "metrica/rails/railtie" if defined?(Rails)
