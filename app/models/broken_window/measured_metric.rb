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
      @measurement ||= @metric.latest_measurement unless container?
    end

    def status
      @status ||= calculate_status
    end

    def old?
      measurement && measurement.created_at < 3.days.ago
    end

    def children
      @metric.children.map do |metric|
        self.class.new(metric)
      end
    end

    def self.model_name
      Metric.model_name
    end

    def to_model
      metric
    end

    delegate :name, :to_param, :threshold, :value_type, :threshold_type, :container?, to: :metric
    delegate :value, to: :measurement, allow_nil: true

    private

    def calculate_status
      if container?
        MetricStatus.combine(children.map(&:status))
      else
        StatusChecker.check_status(@metric, measurement)
      end
    end
  end
end