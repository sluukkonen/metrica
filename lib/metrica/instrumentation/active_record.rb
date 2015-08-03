module Metrica
  module Rails
    module Instrumentation
      # @api private
      module ActiveRecord

        include Metrica::Measurable
        instrument_method :log, "request.db"

      end
    end

  end
end