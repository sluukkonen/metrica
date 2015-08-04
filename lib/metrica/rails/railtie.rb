module Metrica
  module Rails
    # @api private
    class Railtie < ::Rails::Railtie

      initializer "mertike.middleware" do |app|
        app.middleware.insert(0, Metrica::Rack::Middleware)
      end

      config.after_initialize do
        # Insert ActiveRecord instrumentation
        if defined?(::ActiveRecord::ConnectionAdapters::AbstractAdapter)
          require_relative "../instrumentation/active_record"
          ::ActiveRecord::ConnectionAdapters::AbstractAdapter.
              send(:include, Metrica::Instrumentation::ActiveRecord)
        end

        # Insert ActionController instrumentation
        if defined?(::ActionController::Base)
          require_relative "../instrumentation/action_controller"
          ::ActionController::Base.
              send(:include, Metrica::Instrumentation::ActionController)
        end

        # Insert Redis instrumentation
        if defined?(::Redis::Client)
          require_relative "../instrumentation/redis"
          ::Redis::Client.
              send(:include, Metrica::Instrumentation::Redis)
        end
      end

      config.to_prepare do
        start_metrica = Metrica.config.environments.include?(::Rails.env)
        running_rake = File.basename($0) == 'rake'
        running_rails_console = File.basename($0) == 'rails' &&
            ::Rails.const_defined?('Console')

        if start_metrica && !running_rake && !running_rails_console
          Metrica.start
        end
      end

    end
  end
end
