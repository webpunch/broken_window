class AddSnoozedAtToMetric < ActiveRecord::Migration[4.2]
  def change
    add_column :broken_window_metrics, :snoozed_at, :datetime
  end
end
