class AddThresholdPeriodToMetrics < ActiveRecord::Migration[5.2]
  def change
    add_column :broken_window_metrics, :threshold_period, :integer, null: false, default: 1
  end
end
