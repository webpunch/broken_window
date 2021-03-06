module BrokenWindow
  class Metric < ActiveRecord::Base
    VALUE_TYPES = %w(percentage integer)
    THRESHOLD_TYPES = %w(min max)
    VALID_CLASS_NAME = /\A[A-Z][a-zA-Z_0-9\:]*\z/

    SNOOZE_INTERVAL = 2.weeks

    has_many :measurements

    validates :name, presence: true, length: { maximum: 255 }
    validates :calculator, format: { with: VALID_CLASS_NAME, allow_blank: true, message: "must be a valid class name" }
    validates :value_type, inclusion: { in: VALUE_TYPES }
    validates :threshold, presence: true, numericality: { allow_blank: true }, unless: :container?
    validates :threshold_period, presence: true, numericality: { allow_blank: true, greater_than_or_equal_to: 1 }, unless: :container?
    validates :threshold_type, inclusion: { in: THRESHOLD_TYPES }

    acts_as_tree order: "name"

    def latest_measurement
      measurements.order(created_at: :asc, id: :asc).last
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

    def container?
      calculator.blank?
    end

    def snooze!
      update!(snoozed_at: Time.now)
    end

    def snoozed?
      snoozed_at && snoozed_at >= SNOOZE_INTERVAL.ago
    end

    def unsnooze!
      update!(snoozed_at: nil)
    end
  end
end
