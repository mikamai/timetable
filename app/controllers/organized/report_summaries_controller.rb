# frozen_string_literal: true

module Organized
  class ReportSummariesController < BaseController
    before_action :set_week_range, except: :index

    def index
      week_id = Date.today.strftime TimeEntry::WEEK_ID_FORMAT
      redirect_to clients_organization_report_summary_path(id: week_id)
    end

    def clients
      @rows = ReportSummaries::ClientRow.build_from_scope time_entries
      render 'show'
    end

    def projects
      @rows = ReportSummaries::ProjectRow.build_from_scope time_entries
      render 'show'
    end

    def tasks
      @rows = ReportSummaries::TaskRow.build_from_scope time_entries
      render 'show'
    end

    def team
      @rows = ReportSummaries::UserRow.build_from_scope time_entries
      render 'show'
    end

    private

    def time_entries
      @time_entries ||= policy_scope(
        TimeEntry.in_organization(current_organization)
                 .executed_since(@beginning_of_week)
                 .executed_until(@end_of_week)
      )
    end

    def set_week_range
      @beginning_of_week = Date.strptime(params[:id], TimeEntry::WEEK_ID_FORMAT).beginning_of_week
      @end_of_week = @beginning_of_week.end_of_week
    rescue ArgumentError
      raise ActiveRecord::RecordNotFound, 'dates are not valid'
    end
  end
end
