# frozen_string_literal: true

module Organized
  class TimeOffViewsController < BaseController
    helper_method :impersonatable_users, :impersonating_user, :impersonating_or_current_user

    def index
      redirect_to [current_organization, TimeOffView.today(current_organization, current_user)]
    end

    def show
      @time_off_view = TimeOffView.find(params[:id], current_organization, current_user)
      authorize @time_off_view
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
