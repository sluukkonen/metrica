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

      def perform
        start
        yield
      ensure
        stop
      end

    end
  end
end
