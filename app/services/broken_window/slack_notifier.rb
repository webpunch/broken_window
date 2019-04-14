require "json"

module BrokenWindow
  class SlackNotifier
    class <<self
      def call
        calculated_metrics = BrokenWindow::Metric.where.not(calculator: nil).map { |metric| BrokenWindow::MeasuredMetric.new(metric) }
        failed_metrics = calculated_metrics.select { |metric| metric.status.to_s == "fail" }
        formatted_metrics_text = format_metrics(failed_metrics)

        BrokenWindow.slack_webhook_urls.each do |url|
          send_message(url, formatted_metrics_text)
        end
      end

      private

      def format_metrics(metrics)
        if metrics.empty?
          ":heavy_check_mark: No broken window metrics failed"
        else
          "These metrics are failing in broken window:\n\n" + metrics.map{ |metric| format_metric(metric) }.join("\n\n")
        end
      end

      def format_metric(metric)
        "#{metric_status(metric)} <#{BrokenWindow.base_url}/status/#{metric.id}|#{metric.name}>"
      end

      def metric_status(metric)
        case metric.status.to_s
        when "pass"
          ":heavy_check_mark:"
        when "fail"
          ":negative_squared_cross_mark:"
        else
          raise ArgumentError.new("Undefined metric status: #{metric.status.to_s}")
        end
      end

      def send_message(url, text)
        url = URI(url)
        req = Net::HTTP::Post.new(url, "Content-Type" => "application/json")
        req.body = { text: text }.to_json
        res = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
          http.request(req)
        end
      end
    end
  end
end
