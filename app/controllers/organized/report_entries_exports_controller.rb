# frozen_string_literal: true

module Organized
  class ReportEntriesExportsController < BaseController
    def create
      @export = current_organization.report_entries_exports.create!(
        user:         current_user,
        export_query: params[:q]
      )
      ExportReportEntriesJob.perform_later @export
      redirect_to [current_organization, @export]
    end

    def show
      @export = current_organization.report_entries_exports.find params[:id]
      authorize @export
    end
  end
end
