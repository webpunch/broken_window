module BrokenWindow
  class MetricMeasurer
    include Service

    def initialize(metric)
      @metric = metric
    end

    def call
      value = calculator.call
      @metric.measurements.create!(value: value)
    end

    private

    def calculator
      calculator_class.new(ActiveSupport::HashWithIndifferentAccess.new(@metric.arguments_hash))
    end

    def calculator_class
      raise ArgumentError unless @metric.calculator

      @metric.calculator.constantize
    end
  end
end