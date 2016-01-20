module BrokenWindow
  class Measurer
    include Service

    def call
      Metric.all.each do |metric|
        MetricMeasurer.call(metric)
      end
    end
  end
end