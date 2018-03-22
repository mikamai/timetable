# frozen_string_literal: true

module HoursAmount
  extend ActiveSupport::Concern

  class_methods do
    def add_hours_amount_to field
      method_name = "time_#{field}"
      define_method method_name do
        memoized_amount = instance_variable_get "@#{method_name}"
        return memoized_amount if memoized_amount
        format_as_hours send(field)
      end

      define_method "#{method_name}=" do |val|
        instance_variable_set "@#{method_name}", val
        assign_attributes field => parse_hours(val)
      end
    end
  end

  private

  def format_as_hours amount
    return nil unless amount
    hours = amount / 60
    minutes = amount % 60
    "#{hours}:#{minutes.to_s.rjust 2, '0'}"
  end

  def parse_hours val
    parse_float_hours(val) || parse_string_hours(val) || val
  end

  def parse_float_hours val
    return nil unless val.to_s.match?(/^\d+([\.,]?\d+)$/)
    (val.to_s.sub(',', '.').to_f * 60).to_i
  end

  def parse_string_hours val
    match = val.to_s.match(/\A(\d+)(:(\d+))?\z/)
    return match[1].to_i * 60 + (match[3] || '').to_i if match
  end
end
