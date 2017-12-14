# frozen_string_literal: true

module Organized
  class ReportEntriesController < BaseController
    def index
      @q = current_organization.time_entries.ransack(params[:q]).tap do |q|
        q.sorts = 'execute_on asc' if q.sorts.empty?
      end
      @time_entries = @q.result.includes(:project, :client, :task, :user)
                        .page(params[:page])
    end
  end
end
