# Metrica [![Build Status](https://travis-ci.org/sluukkonen/metrica.svg?branch=master)](https://travis-ci.org/sluukkonen/metrica)

[Dropwizard Metrics](https://dropwizard.github.io/metrics/3.1.0/) for your JRuby apps.

Metrica allows you to collect runtime metrics from your application in your production environment. It's mainly 
designed to work with Ruby on Rails, but it should work well in all kinds of Ruby apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metrica'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metrica
    
## Documentation

[API Documentation](http://www.rubydoc.info/github/sluukkonen/metrica/master)

## Usage

If you're using Rails, Metrica comes out-of-the-box with a Rack middleware that collects some useful 
metrics about your application.

Metric name            | Type    | Description
-----------------------|---------|----------------------------------------------------------
activeRequests         | Counter | The number of requests that are currently being processed.
request.total          | Timer   | The total time spent processing each request.
request.controller     | Timer   | The time spent in the controller (includes time spent rendering the views).
request.rendering      | Timer   | The time spent rendering views.
request.db             | Timer   | The time spent performing SQL queries.
request.redis          | Timer   | The time spent performing Redis commands.
statusCodes.ok         | Meter   | The number of 200 OK responses.
statusCodes.created    | Meter   | The number of 201 Created responses.
statusCodes.noContent  | Meter   | The number of 204 No Content responses.
statusCodes.badRequest | Meter   | The number of 400 Bad Request responses.
statusCodes.notFound   | Meter   | The number of 404 Not Found responses.
statusCodes.error      | Meter   | The number of 500 Internal Server Error responses.

To configure Metrica, add an initializer.

```ruby
# config/initializers/metrica.rb

Metrica.configure do |config|
  config.environments = %w(staging production)            # The environments where Metrica should run.
  config.reporters << Metrica::Reporters::JmxReporter.new # Publish the metrics to JMX.
end
```

If you're not using Rails, you'll have to call `Metrica.start` manually to start
the reporters.

## Available Metrics

Metrica metric objects are raw Java objects from the Dropwizard Metrics library,
so if you are already familiar with it, using metrica should be easy.

See [Dropwizard Metrics's Javadoc](https://dropwizard.github.io/metrics/3.1.0/apidocs/) for a full list of methods in each metric.

### Meters

A meter measures the rate of events over time (e.g., “requests per second”) as well as 1-, 5-, and 15-minute moving 
averages.

```ruby
class RequestProcessor
  def initialize
    @meter = Metrica.meter("requests")
  end
  
  def process(request)
    @meter.mark
    # Process the request…
  end
  
end
```

### Counters

A counter is just a number you can increment or decrement atomically.

```ruby
class RequestProcessor
  def initialize
    @counter = Metrica.counter("active-requests")
  end
  def process(request)
    @counter.inc
    # Process the request…
  ensure
    @counter.dec
  end
end
```

### Histograms

A histogram measures the statistical distribution of values in a stream of data. 
In addition to minimum, maximum, mean, etc., it also measures 50th, 75th, 
90th, 95th, 98th, 99th, and 99.9th percentiles.

The default Histogram implementation uses [reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling) to minimize memory usage, but its behavior is [customizable](https://dropwizard.github.io/metrics/3.1.0/manual/core/#histograms).

```ruby
class RequestProcessor
  def initialize
    @histogram = Metrica.histogram("request-sizes")
  end
  def process(request)
    @histogram.update(request.size)
    # Process the request…
  end
end
```

### Timers

A Timer measures the rate that a particular piece of code is called and the
distribution of its duration.

```ruby
class RequestProcessor
  def initialize
    @timer = Metrica.timer("requests")
  end
  def process(request)
    context = @timer.time do 
    # Process the request…
    ensure
      context.stop
    end
  end
end
```

Metrica also adds a handy `measure` method to the `Timer` class for ease-of-use.

```ruby
class RequestProcessor
  def initialize
    @timer = Metrica.timer("requests")
  end
  def process(request)
    @timer.measure do 
      # Process the request…
    end
  end
end
```

### Customizing metrics

If you want to customize a metric (see Dropwizard Metrics [documentation](https://dropwizard.github.io/metrics/3.1.0/getting-started/)
for more information), you can register a custom metric by using
the `Metrica.register` method.

For example, if you want to use a timer with a `SlidingTimeWindowReservoir` 
instead of the default `ExponentiallyDecayingReservoir`, you can register it 
as follows.

```ruby
class RequestProcessor
   
  def initialize
    reservoir = Metrica::SlidingTimeWindowReservoir.new(5, Metrica::TimeUnit::SECONDS)
    @timer = Metrica.register("requests", Metrica::Timer.new(reservoir))
  end
  def process(request)
    @timer.measure do 
      # Process the request…
    end
  end
end
```

## Reporters

Collecting metrics isn't enough, you'll also need to report them somewhere.
Metrica can report the metrics to the following systems:

* Console
* JMX
* [Graphite](http://graphite.wikidot.com)
* [OpenTSDB](http://opentsdb.net)

### Reporting to Console

```ruby
Metrica.configure do |config|
  config.reporters << Metrica::Reporters::ConsoleReporter.new
end
```

### Reporting to JMX

```ruby
Metrica.configure do |config|
  config.reporters << Metrica::Reporters::JMXReporter.new
end
```

### Reporting to Graphite

```ruby
Metrica.configure do |config|
  config.reporters << Metrica::Reporters::GraphiteReporter.new(hostname: "localhost", port: 2003)
end
```

### Reporting to OpenTSDB

```ruby
Metrica.configure do |config|
  config.reporters << Metrica::Reporters::OpenTSDBReporter.new(url: "http://localhost:4242")
end
```

## Contributing

Feedback, ideas, bug reports and pull requests are welcome on GitHub at https://github.com/sluukkonen/metrica.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

