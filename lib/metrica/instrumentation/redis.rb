module Metrica
  module Rails
    module Instrumentation
      # @api private
      module Redis

        include Metrica::Measurable
        instrument_method :logging, "request.redis"

      end
    end
  end
end