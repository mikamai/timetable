# frozen_string_literal: true

module ReportSummaries
  class Base
    include ActiveModel::Model

    define_model_callbacks :initialize, only: :after

    class << self
      def find_by_week organization, year, week
        new year: year, week: week, organization: organization
      end
    end

    attr_accessor :year, :week, :organization
    attr_reader :beginning_of_week, :end_of_week

    after_initialize :set_dates

    def initialize attrs = {}
      super attrs
      run_callbacks :initialize
    end

    def time_entries
      TimeEntry.in_organization(organization)
               .executed_since(beginning_of_week)
               .executed_until(end_of_week)
    end

    def total_amount
      time_entries.total_amount
    end

    private

    def set_dates
      @beginning_of_week = Date.commercial year, week, 1
      @end_of_week = Date.commercial year, week, 7
    rescue ArgumentError
      raise InvalidIdError
    end
  end
end
