module BrokenWindow
  module Formatters
    class Percentage
      include ActionView::Helpers::NumberHelper

      def call(value)
        number_to_percentage(value, precision: 0) if value
      end
    end
  end
end