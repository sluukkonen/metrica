module Metrica
  module Reporters
    # ConsoleReporter reports metrics by printing them out to the standard
    # output.
    class ConsoleReporter < Metrica::ScheduledReporter

      def initialize(options = {})
        super

        @underlying = com.codahale.metrics.ConsoleReporter.
          forRegistry(Metrica.registry).build
      end

    end
  end
end
