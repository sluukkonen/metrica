module Metrica
  # A base class for all scheduled reporters.
  #
  # @api private
  # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/ScheduledReporter.html
  class ScheduledReporter < Reporter
    def start
      underlying.start(Metrica.config.report_interval.to_i, TimeUnit::SECONDS)
    end
  end
end
