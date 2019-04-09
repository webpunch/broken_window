module BrokenWindow
  class StatusChecker
    class << self
      def check_status(metric)
        if metric.value
          if value_passes_threshold?(metric.value, metric.threshold, metric.threshold_type)
            BrokenWindow::MetricStatus.pass
          else
            BrokenWindow::MetricStatus.fail
          end
        else
          BrokenWindow::MetricStatus.unknown
        end
      end

      private

      def value_passes_threshold?(value, threshold, threshold_type)
        value.send(comparison_method(threshold_type), threshold)
      end

      def comparison_method(threshold_type)
        case threshold_type
        when 'min'
          return '>=';
        when 'max'
          return '<=';
        else
          raise "unknown threshold_type #{threshold_type.inspect}"
        end
      end
    end
  end
end
