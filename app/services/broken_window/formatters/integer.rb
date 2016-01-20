module BrokenWindow
  module Formatters
    class Integer
      include ActionView::Helpers::NumberHelper

      def call(value)
        value.to_i.to_s if value
      end
    end
  end
end