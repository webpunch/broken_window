class AddSnoozedAtToMetric < ActiveRecord::Migration
  def change
    add_column :broken_window_metrics, :snoozed_at, :datetime
  end
end
