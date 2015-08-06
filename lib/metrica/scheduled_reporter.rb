module Metrica
  # A base class for all scheduled reporters.
  #
  # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/ScheduledReporter.html
  class ScheduledReporter < Reporter

    def initialize(options = {})
      @report_interval = (options[:report_interval] || Metrica.config.report_interval).to_i
      parse_additional_options(options)
    end

    def start
      @underlying.start(@report_interval, TimeUnit::SECONDS)
    end

    protected

    def parse_additional_options(options)
      # Override in a subclass
    end
  end
end
