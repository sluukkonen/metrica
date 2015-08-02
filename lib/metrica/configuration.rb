require "logger"

# A class that holds the current configuration of Metrica.
class Metrica::Configuration

  # An array of reporters that are currently active.
  #
  # @!attribute [rw] reporters
  # @return [Array<Metrica::Reporter>]
  attr_accessor :reporters

  # A prefix that is added to each metric, if the reporter supports this
  # feature. It's recommended to replace this with the name of your
  # application.
  #
  # @!attribute [rw] prefix
  # @return [String] .
  attr_accessor :prefix

  # An array of Rails environments where Metrika should automatically be
  # started. Metrika determines the current environment from the
  # +RAILS_ENV+ environment variable. By default, the array contains only the
  # production environment.
  #
  # @!attribute [rw] environments
  # @return [Array<String>]
  attr_accessor :environments

  # The time interval in seconds how often scheduled reporters do the reporting.
  # By default, 30 seconds.
  #
  # @!attribute [rw] report_interval
  # @return [Integer]
  attr_accessor :report_interval

  # The logger that Metrica uses. By default, Metrica logs to +STDOUT+.
  #
  # @!attribute [rw] logger
  # @return [Logger]
  attr_accessor :logger

  def initialize
    @prefix = nil
    @environments = %w(production)
    @reporters = []
    @report_interval = 30
    @logger = defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
  end

end