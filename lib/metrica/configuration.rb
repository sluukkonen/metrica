require "logger"

# A class that holds the current configuration of Metrica.
class Metrica::Configuration

  # An array of reporters that Metrica should report to.
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

  # An array of Rails environments where Metrica should automatically be
  # started. Metrica determines the current environment from the
  # +RAILS_ENV+ environment variable.
  #
  # By default, production.
  #
  # @!attribute [rw] environments
  # @return [Array<String>]
  attr_accessor :environments

  # How often scheduled reporters do the reporting.
  #
  # By default, 30 seconds.
  #
  # @!attribute [rw] report_interval
  # @return [Integer]
  attr_accessor :report_interval

  def initialize
    @prefix = nil
    @environments = %w(production)
    @reporters = []
    @report_interval = 30
  end

end