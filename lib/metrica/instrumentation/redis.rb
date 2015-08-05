module Metrica
  module Instrumentation
    # @api private
    module Redis

      def self.included(base)
        base.class_eval do
          extend Metrica::MethodInstrumentation
          instrument_method :logging, "request.redis", within_transaction: true
        end
      end

    end
  end
end