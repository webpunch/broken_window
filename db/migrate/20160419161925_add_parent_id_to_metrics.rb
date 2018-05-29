class AddParentIdToMetrics < ActiveRecord::Migration[4.2]
  def change
    add_column :broken_window_metrics, :parent_id, :integer
  end
end
