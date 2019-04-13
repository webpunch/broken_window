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

    def daily_measurements
      @daily_measurements ||= measurements
        .group_by{ |measurement| measurement.created_at.to_date }
        .map{ |_, measurements_for_date| measurements_for_date.max_by(&:created_at) }
        .sort_by(&:created_at)
    end

    def value
      @value ||= threshold_measurements.any? ? (threshold_measurements.sum(&:value) / threshold_measurements.size) : nil
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

    private

    def calculate_status
      return MetricStatus.snoozed if snoozed?

      if container?
        MetricStatus.combine(children.map(&:status))
      else
        StatusChecker.check_status(self)
      end
    end

    def threshold_measurements
      @threshold_measurements ||= daily_measurements.select { |measurement| measurement.created_at > metric.threshold_period.days.ago.beginning_of_day }
    end
  end
end
