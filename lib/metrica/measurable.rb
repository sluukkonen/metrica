module Metrica
  # A utility module that can be used to add measuring capabilities to a class.
  # Marking a method with +instrument_method+ wraps it in a
  # +com.codahale.metrics.Timer+.
  #
  # @example Adding instrumentation to a method
  #   class MyClass
  #     def foo(a, b)
  #       ...
  #     end
  #     instrument_method :foo, 'myapp.foo'
  #   end
  #
  # @see https://dropwizard.github.io/metrics/3.1.0/apidocs/com/codahale/metrics/Timer.html
  module Measurable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Decorates the method with a timer that can be used for benchmarking.
      #
      # @param method_name [Symbol] The name of the method.
      # @param metric_name [String] The name of the metric.
      def instrument_method(method_name, metric_name)
        timer_name = "_metrica_#{method_name}_timer"
        uninstrumented_method = "#{method_name}_without_instrumentation"

        alias_method uninstrumented_method, method_name
        class_eval <<-RUBY, __FILE__, __LINE__
          @@#{timer_name} = Metrica.timer("#{metric_name}")
          def #{method_name}(*args, &block)
            if Metrica::Transaction.active?
              @@#{timer_name}.measure do
                #{uninstrumented_method}(*args, &block)
              end
            else
              #{uninstrumented_method}(*args, &block)
            end
          end
        RUBY
      end
    end

  end
end