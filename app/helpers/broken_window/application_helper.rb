module BrokenWindow
  module ApplicationHelper
    def metric_up_path(metric)
      if metric.parent
        metric_path metric.parent
      else
        metrics_path
      end
    end
  end
end
