# frozen_string_literal: true

module Organized
  class TimeOffEntryPolicy < BasePolicy
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
      admin? && record_in_scope?
    end

    def destroy?
      update?
    end

    def approve?
      update?
    end

    def decline?
      update?
    end
  end
end
