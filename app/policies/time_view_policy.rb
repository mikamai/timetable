class TimeViewPolicy < ApplicationPolicy
  attr_reader :user, :time_view

  def initialize user, time_view
    @user = user
    @time_view = time_view
  end

  def show?
    return true if time_view.user == user
    show_for_others?
  end

  def show_for_others?
    user.admin?
  end

  def create?
    time_entry = TimeEntry.new user: time_view.user
    TimeEntryPolicy.new(user, time_entry).create?
  end
end
