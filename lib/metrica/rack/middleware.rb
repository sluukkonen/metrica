module Metrica
  module Rack
    class Middleware
      def initialize(app)
        @app = app

        @active_requests = Metrica.counter("activeRequests")
        @request_timer = Metrica.timer("request.total")
        @default_status_meters = {
            200 => Metrica.meter("statusCodes.ok"),
            201 => Metrica.meter("statusCodes.created"),
            204 => Metrica.meter("statusCodes.noContent"),
            400 => Metrica.meter("statusCodes.badRequest"),
            404 => Metrica.meter("statusCodes.notFound"),
            500 => Metrica.meter("statusCodes.serverError"),
        }
        @error_status_meter = @default_status_meters[500]
        @other_status_meter = Metrica.meter("statusCodes.other")
      end

      def call(env)
        @active_requests.inc

        begin
          result = @request_timer.measure { @app.call(env) }
          status = result[0]
          status_meter = @default_status_meters[status] || @other_status_meter
          status_meter.mark
        rescue Exception => e
          @error_status_meter.mark
          raise e
        ensure
          @active_requests.dec
        end

        result
      end

    end
  end
end
