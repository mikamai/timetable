module Organized
  class ReportEntriesController < BaseController
    before_action :set_basic_filters

    helper_method :from_date, :to_date

    def index
      @time_entries = TimeEntry.includes(:project, :client, :task, :user)
                               .executed_since(from_date)
                               .executed_until(to_date)
                               .order(:executed_on, :created_at)
      @time_entries_by_date = group_time_entries_by_date
    end

    private

    def from_date
      return nil unless params[:from_id].present?
      @from_date ||= Date.strptime params[:from_id], TimeView::ID_FORMAT
    rescue ArgumentError
      nil
    end

    def to_date
      return nil unless params[:to_id].present?
      @to_date ||= Date.strptime params[:to_id], TimeView::ID_FORMAT
    rescue ArgumentError
      nil
    end

    def set_basic_filters
      return if from_date || to_date
      redirect_to organization_report_entries_path(
        from_id: Date.today.beginning_of_week.strftime(TimeView::ID_FORMAT),
        to_id:   Date.today.end_of_week.strftime(TimeView::ID_FORMAT),
      )
    end

    def group_time_entries_by_date
      @time_entries.inject [] do |memo, item|
        array = memo.last
        if array && array.last.executed_on == item.executed_on
          array << item
        else
          memo << [item]
        end
        memo
      end
    end
  end
end
