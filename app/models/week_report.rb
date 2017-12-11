# frozen_string_literal: true

class WeekReport
  include ActiveModel::Model

  class << self
    def find_by_current_week organization
      today = Date.today
      new year: today.cwyear, week: today.cweek, organization: organization
    end
  end

  attr_accessor :year, :week, :organization

  def beginning_of_week
    @beginning_of_week = Date.commercial(year, week, 1)
  end

  def end_of_week
    @beginning_of_week = Date.commercial(year, week, 7)
  end

  def total_amount
    TimeEntry.in_organization(organization)
             .executed_since(beginning_of_week)
             .executed_until(end_of_week)
             .total_amount
  end
end
