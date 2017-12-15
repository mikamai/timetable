# frozen_string_literal: true

module Organized
  class TimeViewsController < BaseController
    def show
      @week_view = WeekView.find_by_time_view_id params[:id], current_organization, impersonating_user
      @time_view = @week_view.selected_time_view
      authorize @time_view
    end

    private

    def impersonating_user
      @impersonating_user ||= current_organization.users.find params[:as]
    rescue ActiveRecord::RecordNotFound
      current_user
    end
  end
end
