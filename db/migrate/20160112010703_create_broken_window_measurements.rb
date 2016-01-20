class CreateBrokenWindowMeasurements < ActiveRecord::Migration
  def change
    create_table :broken_window_measurements do |t|
      t.integer :metric_id
      t.decimal :value
      t.datetime :created_at
    end
  end
end
