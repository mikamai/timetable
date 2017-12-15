class TimeEntryPolicy < ApplicationPolicy
  attr_reader :user, :time_entry

  def initialize user, time_entry
    @user = user
    @time_entry = time_entry
  end

  def create?
    return true if user == time_entry.user
    user.admin?
  end

  def update?
    create?
  end
end
