require 'spec_helper'

module BrokenWindow
  class DummyCalculator
    def initialize(*args)
    end

    def call
      50
    end
  end

  RSpec.describe MetricsController, :type => :controller do
    routes { BrokenWindow::Engine.routes }
    let(:metric) { Metric.create!(name: 'Percentage scraped', calculator: 'DummyCalculator', value_type: 'percentage', threshold: 50.0, threshold_type: 'min') }

    describe "#show" do
      it "displays as unknown if there have never been any measurements" do
        get :show, params: { id: metric }

        expect(assigns(:status).to_s).to eq('unknown')
      end

      it "displays as pass if there the latest measurement is above the minimum" do
        metric.measurements.create!(value: 52.0)

        get :show, params: { id: metric }

        expect(assigns(:status).to_s).to eq('pass')
      end

      it "displays as snoonzed if the metric has been snoozed" do
        metric.measurements.create!(value: 12.0)
        metric.snooze!

        get :show, params: { id: metric }

        expect(assigns(:status).to_s).to eq('snoozed')
      end
    end
  end
end
