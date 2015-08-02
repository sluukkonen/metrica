module Metrica
  module Rails
    module Instrumentation
      module Redis

        include Metrica::Measurable
        instrument_method :logging, "redis.commands"

      end
    end
  end
end