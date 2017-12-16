class TimeViewPolicy < ApplicationPolicy
  def show?
    return true if record.user == user
    show_for_others?
  end

  def show_for_others?
    user.admin?
  end

  def create?
    time_entry = TimeEntry.new user: record.user
    TimeEntryPolicy.new(user, time_entry).create?
  end
end
