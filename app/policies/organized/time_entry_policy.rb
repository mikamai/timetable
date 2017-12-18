module Organized
  class TimeEntryPolicy < BasePolicy
    class Scope < Scope
      def resolve
        return scope if admin?
        scope.executed_by user
      end
    end

    def create?
      return true if user == record.user
      admin?
    end

    def update?
      create?
    end
  end
end
