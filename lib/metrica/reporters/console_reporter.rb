module Metrica
  module Reporters
    class ConsoleReporter < Metrica::ScheduledReporter

      attr_reader :underlying

      def initialize
        @underlying = com.codahale.metrics.ConsoleReporter.
          forRegistry(Metrica.registry).build
      end

    end
  end
end
