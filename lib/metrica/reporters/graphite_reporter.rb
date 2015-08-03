module Metrica
  module Reporters
    # GraphiteReporter reports the metrics to a Graphite server.
    # @see http://graphite.wikidot.com
    class GraphiteReporter < ScheduledReporter

      # @option options [String] :hostname The hostname of the Graphite server.
      # @option options [Integer] :port The port number of the Graphite server.
      # @option options [Integer] :report_interval How often the metrics are
      #   reported to the Graphite server, in seconds.
      def initialize(options = {})
        super

        require_relative "../../jars/metrics-graphite-3.1.2.jar"
        address = java.net.InetSocketAddress.new(@hostname, @port)
        graphite = com.codahale.metrics.graphite.Graphite.new(address)
        @underlying = com.codahale.metrics.graphite.GraphiteReporter.
            forRegistry(Metrica.registry).
            prefixedWith(Metrica.config.prefix).
            build(graphite)
      end

      private

      def parse_additional_options(options)
        @hostname = options[:hostname] || 'localhost'
        @port = options[:port] || 2003
      end
    end
  end
end