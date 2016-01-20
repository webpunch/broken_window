module BrokenWindow
  class Metric < ActiveRecord::Base
    VALUE_TYPES = %w(percentage integer)
    THRESHOLD_TYPES = %w(min max)
    VALID_CLASS_NAME = /\A[A-Z][a-zA-Z_0-9\:]*\z/

    has_many :measurements

    validates :name, presence: true, length: {maximum: 255}
    validates :calculator, presence: true, format: {
      with: VALID_CLASS_NAME, allow_nil: true, message: "must be a valid class name" }
    validates :value_type, inclusion: {in: VALUE_TYPES}
    validates :threshold, presence: true, numericality: {allow_nil: true}
    validates :threshold_type, inclusion: {in: THRESHOLD_TYPES}

    def latest_measurement
      measurements.latest_first.first
    end

    def arguments_hash
      if arguments.present?
        YAML::load(arguments)
      else
        {}
      end
    end

    def self.format_value(value, value_type)
      formatter = "BrokenWindow::Formatters::#{value_type.camelize}".constantize.new
      formatter.call(value)
    end

  end
end
