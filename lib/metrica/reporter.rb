module Metrica

  # A convenience class that wraps a Java Reporter from the metrics library.
  # @api private
  # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Reporter.html
  class Reporter

    # Returns the underlying Java Reporter.
    #
    # @return [com.codahale.metrics.Reporter]
    def underlying
      raise NotImplementedError, "This method should be overridden!"
    end

    # Starts the underlying Reporter.
    def start
      underlying.start
    end

    # Stops the underlying Reporter.
    def stop
      underlying.stop
    end

  end
end
