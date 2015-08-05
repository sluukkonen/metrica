module Metrica
  module Instrumentation
    # @api private
    module ActiveRecord

      def self.included(base)
        base.class_eval do
          extend Metrica::MethodInstrumentation
          instrument_method :log, "request.db", within_transaction: true
        end
      end

    end
  end
end