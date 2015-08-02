require "socket"

module Metrica
  module Reporters

    class OpenTSDBReporter < Metrica::ScheduledReporter

      attr_reader :underlying

      def initialize(options = {})
        require_relative "../../jars/metrics-opentsdb-1.0.4.jar"

        @tags = {host: Socket.gethostname}.merge(options[:tags] || {})
        @url = options[:url] || "http://localhost:4242"

        opentsdb = com.github.sps.metrics.opentsdb.OpenTsdb.
            forService(@url).create
        @underlying = com.github.sps.metrics.OpenTsdbReporter.
            forRegistry(Metrica.registry).
            prefixedWith(Metrica.config.prefix).
            withTags(to_java_hashmap(@tags)).
            build(opentsdb)
      end

      private

      def to_java_hashmap(hash)
        java.util.HashMap.new.tap do |map|
          hash.each { |k, v| map.put(k.to_s.to_java(:string),
                                     v.to_s.to_java(:string)) }
        end
      end

    end
  end
end
