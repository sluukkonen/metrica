require "socket"

module Metrica
  module Reporters

    class OpenTSDBReporter < Metrica::ScheduledReporter

      # @option options [String] :url ("http://localhost:4242")
      #   The URL of the OpenTSDB Server.
      # @option options [Hash] :tags ({"host": "the-hostname-of-your-server"})
      #   A set of tags to be attached to each event.
      # @option options [Integer] :report_interval (30)
      #   How often the metrics are reported to the OpenTSDB server, in seconds.
      def initialize(options = {})
        super

        require_relative "../../jars/metrics-opentsdb-1.0.4.jar"
        opentsdb = com.github.sps.metrics.opentsdb.OpenTsdb.
            forService(@url).create
        @underlying = com.github.sps.metrics.OpenTsdbReporter.
            forRegistry(Metrica.registry).
            prefixedWith(Metrica.config.prefix).
            withTags(@tags).
            build(opentsdb)
      end

      protected

      def parse_additional_options(options)
        @tags = {host: Socket.gethostname}.merge(options[:tags] || {})
        @url = options[:url] || "http://localhost:4242"
      end

      def to_java_hashmap(hash)
        java.util.HashMap.new.tap do |map|
          hash.each { |k, v| map.put(k.to_s.to_java(:string),
                                     v.to_s.to_java(:string)) }
        end
      end

    end
  end
end
