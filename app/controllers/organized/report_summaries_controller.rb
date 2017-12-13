module Organized
  class ReportSummariesController < BaseController
    before_action :fetch_report_summary!, only: :show

    helper_method :section_name

    def index
      date = Date.today
      redirect_to organization_report_summary_path(
        current_organization,
        "#{date.cwyear}-#{date.cweek}",
        'projects'
      )
    end

    def show; end

    private

    def section_name
      return params[:section] if %w[projects staff tasks team clients].include? params[:section]
      'projects'
    end

    def report_summary_class
      case section_name
      when 'clients'
        ReportSummaries::Clients
      when 'projects'
        ReportSummaries::Projects
      when 'tasks'
        ReportSummaries::Tasks
      when 'team'
        ReportSummaries::Team
      else
        raise NotImplementedError
      end
    end

    def fetch_report_summary!
      year, week = params[:id].split('-').map(&:to_i)
      @report_summary = report_summary_class.find_by_week current_organization, year.to_i, week.to_i
    end
  end
end
