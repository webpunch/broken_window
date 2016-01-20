require 'spec_helper'

module BrokenWindow
  RSpec.describe MetricsController, :type => :controller do
    routes { BrokenWindow::Engine.routes }
    let(:metric) { Metric.create!(name: 'Percentage scraped', calculator: 'null_calculator', value_type: 'percentage', threshold: 50.0) }

    describe "#show" do
      it "displays as unknown if there have never been any measurements" do
        get :show, id: metric

        expect(assigns(:status).to_s).to eq('unknown')
      end

      it "displays as pass if there the latest measurement is above the minimum" do
        metric.measurements.create!(value: 52.0)

        get :show, id: metric

        expect(assigns(:status).to_s).to eq('pass')
      end
    end
  end
end
