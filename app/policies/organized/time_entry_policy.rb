# frozen_string_literal: true

module Organized
  class TimeEntryPolicy < BasePolicy
    class Scope < Scope
      def resolve
        return scope if admin?
        scope.executed_by user
      end
    end

    def create?
      admin? || user == record.user
    end

    def update?
      create? && record_in_scope?
    end
  end
end
