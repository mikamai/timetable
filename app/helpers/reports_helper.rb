module ReportsHelper
  def prev_week_report_url
    date = @report.beginning_of_week - 1.week
    organization_report_path current_organization, "#{date.cwyear}-#{date.cweek}"
  end

  def next_week_report_url
    date = @report.beginning_of_week + 1.week
    organization_report_path current_organization, "#{date.cwyear}-#{date.cweek}"
  end
end
