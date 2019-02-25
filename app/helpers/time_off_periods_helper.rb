# frozen_string_literal: true

module TimeOffPeriodsHelper
  def format_distance_of_days amount
    "#{amount} day#{'s' if amount > 1}"
  end
end
