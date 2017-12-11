module Organized
  class ReportsController < BaseController
    before_action :fetch_report!, only: :show

    helper_method :section_name

    def index
      date = Date.today
      redirect_to organization_report_path current_organization, "#{date.cwyear}-#{date.cweek}"
    end

    def show; end

    private

    def section_name
      return params[:section] if %w[projects staff].include? params[:section]
      'projects'
    end

    def report_class
      case section_name
      when 'projects'
        Reports::ProjectsReport
      when 'staff'
        Reports::StaffReport
      else
        raise NotImplementedError
      end
    end

    def fetch_report!
      year, week = params[:id].split('-').map(&:to_i)
      @report = report_class.find_by_week current_organization, year.to_i, week.to_i
    end
  end
end
