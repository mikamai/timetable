# frozen_string_literal: true

class WeekView
  include ActiveModel::Model

  class << self
    def find_by_current_week organization, user
      id = Date.today.strftime TimeView::ID_FORMAT
      find_by_time_view_id id, organization, user
    end

    def find_by_time_view_id id, organization, user
      date = Date.strptime id, TimeView::ID_FORMAT
      time_views = (date.beginning_of_week..date.end_of_week).map do |d|
        TimeView.new date: d, organization: organization, user: user
      end
      new organization: organization, user: user, time_views: time_views, selected_id: id
    end
  end

  attr_accessor :time_views, :organization, :user, :selected_id

  def selected_time_view
    time_views.detect { |tv| tv.id == selected_id }
  end

  def total_amount
    TimeEntry.in_organization(organization)
             .executed_since(beginning_date)
             .executed_until(end_date)
             .executed_by(user)
             .total_amount
  end

  def beginning_date
    time_views.first.date
  end

  def end_date
    time_views.last.date
  end
end
