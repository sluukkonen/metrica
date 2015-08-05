module Metrica
  module Instrumentation
    # @api private
    module ActiveRecord

      def self.included(base)
        base.class_eval do
          include Metrica::MethodInstrumentation
          instrument_method :log, "request.db"
        end
      end

    end
  end
end