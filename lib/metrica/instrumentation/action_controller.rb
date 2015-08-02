module Metrica
  module Instrumentation
    module ActionController

      METRICA_CONTROLLER_TIMER = Metrica.timer("controller.processing")
      METRICA_VIEWS_TIMER = Metrica.timer("controller.rendering")

      def process_action(*args)
        METRICA_CONTROLLER_TIMER.measure { super }
      end

      def render(*args)
        METRICA_VIEWS_TIMER.measure { super }
      end

    end
  end
end