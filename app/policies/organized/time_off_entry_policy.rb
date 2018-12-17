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

    def approve?
      admin?
    end

    def decline?
      admin?
    end
  end
end
