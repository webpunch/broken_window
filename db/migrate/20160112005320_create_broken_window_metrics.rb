class CreateBrokenWindowMetrics < ActiveRecord::Migration
  def change
    create_table :broken_window_metrics do |t|
      t.string :name
      t.string :calculator
      t.string :value_type
      t.text :arguments
      t.decimal :threshold
      t.string :threshold_type
      t.timestamps
    end
  end
end
