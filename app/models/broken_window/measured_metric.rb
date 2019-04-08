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

    def latest_measurement
      @latest_measurement ||= @metric.latest_measurement unless container?
    end

    def status
      @status ||= calculate_status
    end

    def old?
      latest_measurement && latest_measurement.created_at < 3.days.ago
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

    delegate :measurements, :name, :to_param, :threshold, :value_type, :threshold_type, :parent, :container?, :snoozed?, to: :metric
    delegate :value, to: :latest_measurement, allow_nil: true

    private

    def calculate_status
      return MetricStatus.snoozed if snoozed?

      if container?
        MetricStatus.combine(children.map(&:status))
      else
        StatusChecker.check_status(@metric, latest_measurement)
      end
    end
  end
end
