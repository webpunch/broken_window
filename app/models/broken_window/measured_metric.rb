module BrokenWindow
  class MeasuredMetric
    attr_reader :metric

    class << self
      def find(param)
        new(BrokenWindow::Metric.find(param))
      end
    end

    def initialize(metric)
      @metric = metric
    end

    def measurement
      @measurement ||= @metric.latest_measurement
    end

    def status
      @status ||= StatusChecker.check_status(@metric, measurement)
    end

    def self.model_name
      Metric.model_name
    end

    def to_model
      metric
    end

    delegate :name, :to_param, :threshold, :value_type, :threshold_type, :persisted?, to: :metric
    delegate :value, to: :measurement, allow_nil: true
  end
end