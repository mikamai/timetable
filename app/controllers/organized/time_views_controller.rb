# frozen_string_literal: true

module Organized
  class TimeViewsController < BaseController
    before_filter :fetch_impersonating_user
    helper_method :impersonatable_users, :impersonating_user

    def index
      redirect_to [current_organization, TimeView.today(current_organization, current_user)]
    end

    def show
      @week_view = WeekView.find_by_time_view_id params[:id], current_organization,
                                                 impersonating_user
      @time_view = @week_view.selected_time_view
      authorize @time_view
    end

    private

    def impersonating_user
      @impersonating_user || current_user
    end

    def default_url_options
      super.tap do |opts|
        if impersonating_user != current_user
          opts.merge! as: impersonating_user.id
        end
      end
    end

    def impersonatable_users
      available_users.where.not id: [impersonating_user.id, current_user.id].uniq
    end

    def fetch_impersonating_user
      return unless params[:as].present?
      @impersonating_user = current_organization.users.find params[:as]
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
