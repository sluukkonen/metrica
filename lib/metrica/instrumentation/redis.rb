module Metrica
  module Rails
    module Instrumentation
      module Redis

        include Metrica::Measurable
        instrument_method :logging, "request.redis"

      end
    end
  end
end