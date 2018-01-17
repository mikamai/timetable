# frozen_string_literal: true

module TimeViewsHelper
  def today_time_view_url
    time_view = TimeView.today(current_organization, current_user)
    organization_time_view_path(current_organization, time_view, as: impersonating_user)
  end

  def prev_week_time_view_url
    date = @time_view.date - 1.day
    time_view = TimeView.new date: date, organization: current_organization, user: current_user
    organization_time_view_path(current_organization, time_view, as: impersonating_user)
  end

  def next_week_time_view_url
    date = @time_view.date + 1.day
    time_view = TimeView.new date: date, organization: current_organization, user: current_user
    organization_time_view_path(current_organization, time_view, as: impersonating_user)
  end
end
