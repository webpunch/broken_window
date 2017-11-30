require 'spec_helper'

module BrokenWindow
  class DummyCalculator
    def initialize(*args)
    end

    def call
      50
    end
  end
end

RSpec.describe "Status page", type: :feature do
  let!(:metric) { BrokenWindow::Metric.create!(name: 'Percentage scraped', calculator: 'DummyCalculator', value_type: 'percentage', threshold: 50.0, threshold_type: 'min') }

  before do
    metric.measurements.create!(value: 12.0)
    metric.snooze!
  end

  scenario "shows metrics" do
    visit '/status'

    expect(page).to have_content "Percentage scraped"
    expect(page).to have_content "12%"
  end
end
