module Organized
  class TimeViewPolicy < BasePolicy
    def show?
      return true if record.user == user
      show_for_others?
    end

    def show_for_others?
      admin?
    end

    def create?
      time_entry = TimeEntry.new user: record.user
      TimeEntryPolicy.new(organization_membership, time_entry).create?
    end
  end
end
