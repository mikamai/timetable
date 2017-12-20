# frozen_string_literal: true

module Organized
  class TimeViewPolicy < BasePolicy
    def show?
      return true if record.respond_to?(:user) && record_in_scope? && record.user == user
      admin? && record_in_scope?
    end

    def create?
      time_entry = TimeEntry.new user: record.user
      TimeEntryPolicy.new(organization_membership, time_entry).create?
    end
  end
end
