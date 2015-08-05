module Metrica
  # @api private
  module Transaction
    class << self

      def active?
        Thread.current[:metrica_transaction_active]
      end

      def start
        Thread.current[:metrica_transaction_active] = true
      end

      def stop
        Thread.current[:metrica_transaction_active] = nil
      end

    end
  end
end