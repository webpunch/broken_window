module BrokenWindow
  class Measurement < ActiveRecord::Base
    belongs_to :metric
  end
end
