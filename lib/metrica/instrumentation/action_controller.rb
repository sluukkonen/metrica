module Metrica
  module Instrumentation
    # @api private
    module ActionController

      @@_metrica_process_action_timer = Metrica.timer("request.controller")
      @@_metrica_render_timer = Metrica.timer("request.rendering")

      def process_action(*args)
        @@_metrica_process_action_timer.measure { super }
      end

      def render(*args)
        @@_metrica_render_timer.measure { super }
      end

    end
  end
end