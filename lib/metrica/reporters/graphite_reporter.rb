module Metrica
  module Reporters
    class GraphiteReporter < ScheduledReporter

      attr_reader :underlying

      def initialize(options = {})
        require_relative "../../jars/metrics-graphite-3.1.2.jar"

        @host = options[:host] || 'localhost'
        @port = options[:port] || 2003

        graphite = com.codahale.metrics.graphite.Graphite.new(
            Java::JavaNet::InetSocketAddress.new(@host, @port)
        )
        @underlying = com.codahale.metrics.graphite.GraphiteReporter.
            forRegistry(Metrica.registry).
            prefixedWith(Metrica.config.prefix).
            build(graphite)
      end
    end
  end
end