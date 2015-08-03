module Metrica

  # A base class for all reporters.
  #
  # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Reporter.html
  class Reporter

    # @!attribute [r] underlying
    #   Returns the underlying Java reporter.
    # @return [com.codahale.metrics.Reporter]
    attr_reader :underlying

    # Starts the underlying Reporter.
    def start
      @underlying.start
    end

    # Stops the underlying Reporter.
    def stop
      @underlying.stop
    end

  end
end
