# frozen_string_literal: true

module Organized
  class TimeViewsController < BaseController
    helper_method :impersonatable_users, :impersonating_user, :impersonating_or_current_user

    def index
      redirect_to [current_organization, TimeView.today(current_organization, current_user)]
    end

    def show
      @week_view = WeekView.find_by_time_view_id params[:id], current_organization,
                                                 impersonating_or_current_user
      @time_view = @week_view.selected_time_view
      authorize @time_view
    end

    private

    def impersonating_user
      return nil unless params[:as]
      @impersonating_user ||= current_organization.users.find params[:as]
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def impersonating_or_current_user
      impersonating_user || current_user
    end

    def impersonatable_users
      available_users.where.not id: [impersonating_user&.id, current_user.id].compact.uniq
    end
  end
end
