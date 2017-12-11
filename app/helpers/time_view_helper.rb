module TimeViewHelper
  def today_time_view_url
    url_for [current_organization, TimeView.today(current_organization, current_user)]
  end

  def prev_week_time_view_url
    time_view = TimeView.new date: @time_view.date - 1.week, organization: current_organization, user: current_user
    url_for [current_organization, time_view]
  end

  def next_week_time_view_url
    time_view = TimeView.new date: @time_view.date + 1.week, organization: current_organization, user: current_user
    url_for [current_organization, time_view]
  end
end
