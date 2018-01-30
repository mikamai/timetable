# frozen_string_literal: true

module Organized
  class ReportEntriesExportsController < BaseController
    def create
      @export = current_organization.report_entries_exports.create!(
        user:         current_user,
        export_query: submitted_export_query
      )
      ExportReportEntriesJob.perform_later @export
      redirect_to [current_organization, @export]
    end

    def show
      @export = current_organization.report_entries_exports.find params[:id]
      authorize @export
    end

    private

    def permitted_params
      params.require(:report_entries_export).permit(:export_query)
    end

    def submitted_export_query
      JSON.parse permitted_params[:export_query]
    rescue JSON::ParserError => e
      raise BadJsonProvidedError.new(e)
    end
  end
end
