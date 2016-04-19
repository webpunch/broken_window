class AddParentIdToMetrics < ActiveRecord::Migration
  def change
    add_column :broken_window_metrics, :parent_id, :integer
  end
end
