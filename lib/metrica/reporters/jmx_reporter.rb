module Metrica
  module Reporters

    class JmxReporter < Metrica::Reporter

      attr_reader :underlying

      def initialize
        @underlying = com.codahale.metrics.JmxReporter.
          forRegistry(Metrica.registry).build
      end

    end
  end
end