module BrokenWindow
  class Measurement < ActiveRecord::Base
    belongs_to :metric

    scope :latest_first, -> { order("created_at DESC") }
  end
end
