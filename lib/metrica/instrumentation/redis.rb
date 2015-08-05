module Metrica
  module Instrumentation
    # @api private
    module Redis

      def self.included(base)
        base.class_eval do
          include Metrica::MethodInstrumentation
          instrument_method :logging, "request.redis"
        end
      end

    end
  end
end