module Metrica
  module Reporters

    class JmxReporter < Metrica::Reporter

      def initialize
        super

        @underlying = com.codahale.metrics.JmxReporter.
          forRegistry(Metrica.registry).build
      end

    end
  end
end