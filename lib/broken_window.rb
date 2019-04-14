require "broken_window/engine"

module BrokenWindow
  class << self
    attr_accessor :base_url, :slack_webhook_urls

    def register_calculators(calculators)
      @calculators ||= []
      @calculators = @calculators + calculators
    end

    def calculators
      @calculators
    end
  end
end
