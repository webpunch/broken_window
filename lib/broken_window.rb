require "broken_window/engine"

module BrokenWindow
  class << self
    def register_calculators(calculators)
      @calculators ||= []
      @calculators = @calculators + calculators
    end

    def calculators
      @calculators
    end
  end
end
