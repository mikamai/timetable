# frozen_string_literal: true

module Organized
  class ReportEntriesController < BaseController
    helper_method :available_clients, :available_projects,
                  :available_tasks, :available_users

    def index
      @q = current_organization.time_entries.ransack(params[:q]).tap do |q|
        q.sorts = 'execute_on asc' if q.sorts.empty?
      end
      @time_entries = @q.result.includes(:project, :client, :task, :user)
                        .page(params[:page])
    end

    private

    def available_clients
      current_organization.clients.by_name
    end

    def available_projects
      current_organization.projects.by_name
    end

    def available_tasks
      current_organization.tasks.by_name
    end

    def available_users
      current_organization.users.by_name
    end
  end
end
