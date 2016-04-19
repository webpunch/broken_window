module BrokenWindow
  class MetricsController < ApplicationController
    layout 'broken_window/application'

    def index
      @metrics = Metric.roots.map {|metric| MeasuredMetric.new(metric)}
      @status = MetricStatus.combine(@metrics.map(&:status))
      @body_class = 'background-metric'
    end

    def show
      @metric = MeasuredMetric.find(params[:id])
      @status = @metric.status
    end

    def new
      @metric = Metric.new
    end

    def create
      @metric = Metric.new(metric_params)
      if @metric.save
        redirect_to @metric
      else
        render action: :new
      end
    end

    def edit
      @metric = Metric.find(params[:id])
    end

    def update
      @metric = Metric.find(params[:id])
      if @metric.update_attributes(metric_params)
        redirect_to @metric
      else
        render action: :edit
      end
    end

    private

    def metric_params
      params[:metric].permit(:name, :threshold, :value_type, :calculator, :arguments, :threshold_type, :parent_id)
    end
  end
end