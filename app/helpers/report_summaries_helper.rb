module ReportSummariesHelper
  def prev_week_report_summary_url report_summary
    date = report_summary.beginning_of_week - 1.week
    organization_report_summary_path current_organization, "#{date.cwyear}-#{date.cweek}"
  end

  def next_week_report_summary_url report_summary
    date = report_summary.beginning_of_week + 1.week
    organization_report_summary_path current_organization, "#{date.cwyear}-#{date.cweek}"
  end
end
