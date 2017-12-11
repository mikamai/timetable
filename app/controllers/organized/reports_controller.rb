module Organized
  class ReportsController < BaseController
    def index
      @week_report = WeekReport.find_by_current_week current_organization
    end
  end
end
