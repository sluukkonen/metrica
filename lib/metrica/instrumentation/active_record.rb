module Metrica
  module Rails
    module Instrumentation
      module ActiveRecord

        include Metrica::Measurable
        instrument_method :log, "db.queries"

      end
    end

  end
end