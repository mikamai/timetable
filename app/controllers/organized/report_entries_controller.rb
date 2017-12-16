# frozen_string_literal: true

module Organized
  class ReportEntriesController < BaseController
    def index
      scoped = policy_scope(current_organization.time_entries)
      @q = scoped.ransack(params[:q]).tap do |q|
        q.sorts = 'execute_on asc' if q.sorts.empty?
      end
      @time_entries = @q.result.includes(:project, :client, :task, :user)
                        .page(params[:page])
    end
  end
end
