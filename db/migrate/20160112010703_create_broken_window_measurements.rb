class CreateBrokenWindowMeasurements < ActiveRecord::Migration[4.2]
  def change
    create_table :broken_window_measurements do |t|
      t.integer :metric_id
      t.decimal :value
      t.datetime :created_at
    end
  end
end
